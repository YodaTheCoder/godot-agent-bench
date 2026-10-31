#!/usr/bin/env bash
# Usage: score_extra.sh <project_dir> <godot_bin> <out_dir>
#
# Task 012 (weapon tests): grades the agent's own test file, tests/test_weapon_extra.gd.
# Called by score.sh after the normal hidden run has written <out_dir>/hidden.xml.
#
# Checks (one JUnit <testcase> each, appended to <out_dir>/hidden.xml):
#   extra_reference_passes   the agent's tests pass with scripts/weapon.gd replaced by
#                            reference_weapon.gd
#   extra_mutant_<n>_caught  the agent's tests fail with the reference plus mutants/<n>.patch
#
# Exit 0 once the checks have been run and recorded (whether they passed or failed);
# non-zero only for internal errors (score.sh then fails the hidden suite).
set -euo pipefail
# Errors inside $(...) (e.g. a mutant that does not apply) must abort too.
shopt -s inherit_errexit

if [ "$#" -ne 3 ]; then
    echo "usage: $0 <project_dir> <godot_bin> <out_dir>" >&2
    exit 2
fi
project=$1 godot=$2 out_dir=$3

here=$(cd "$(dirname "$0")" && pwd)
reference=$here/reference_weapon.gd
mutants_dir=$here/mutants
agent_test_rel=tests/test_weapon_extra.gd
agent_test=$project/$agent_test_rel

[ -f "$reference" ] || { echo "score_extra: missing $reference" >&2; exit 3; }
[ -d "$project" ] || { echo "score_extra: missing project dir $project" >&2; exit 3; }
mkdir -p "$out_dir"
out_dir=$(cd "$out_dir" && pwd)

mutants=()
for n in 1 2 3; do
    [ -f "$mutants_dir/$n.patch" ] || { echo "score_extra: missing $mutants_dir/$n.patch" >&2; exit 3; }
    mutants+=("$n")
done

extra_dir=$out_dir/extra
rm -rf "$extra_dir"
mkdir -p "$extra_dir"
work=$(mktemp -d "$out_dir/extra-work.XXXXXX")
trap 'rm -rf "$work"' EXIT

# Results file: one line per check, "<name>\t<pass|fail>\t<message>".
results=$extra_dir/results.tsv
: >"$results"
record() { printf '%s\t%s\t%s\n' "$1" "$2" "$3" >>"$results"; }

# Run the agent's test file in a fresh copy of the project with the reference weapon,
# optionally with a mutant applied. Prints "pass" or "fail <reason>".
run_suite() {
    local name=$1 patch=${2:-}
    local dir=$work/$name
    mkdir -p "$dir"
    rsync -a --delete --exclude '.git' --exclude 'tests/hidden' "$project"/ "$dir"/
    # Only the agent's file may run: .gutconfig.json would add tests/regression.
    rm -f "$dir/.gutconfig.json"
    mkdir -p "$dir/scripts" "$dir/tests"
    cp "$reference" "$dir/scripts/weapon.gd"
    cp "$agent_test" "$dir/$agent_test_rel"
    if [ -n "$patch" ]; then
        # A mutant that does not apply is an internal error (set -e exits).
        patch -p1 --batch --forward --silent -d "$dir" -i "$patch" >&2
    fi
    if [ ! -d "$dir/.godot" ]; then
        timeout -k 10 300 "$godot" --headless --path "$dir" --import \
            >"$extra_dir/$name-import.log" 2>&1 || true
    fi
    local xml=$extra_dir/$name.xml rc=0
    timeout -k 10 300 "$godot" --headless --path "$dir" -s addons/gut/gut_cmdln.gd \
        "-gtest=res://$agent_test_rel" -gexit "-gjunit_xml_file=$xml" \
        >"$extra_dir/$name.log" 2>&1 || rc=$?
    python3 - "$xml" "$rc" <<'PY'
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

xml, rc = Path(sys.argv[1]), int(sys.argv[2])
if rc in (124, 137):
    print("fail timed out"); sys.exit()
if not xml.is_file():
    print(f"fail no JUnit output (exit {rc})"); sys.exit()
try:
    root = ET.parse(xml).getroot()
except ET.ParseError as e:
    print(f"fail unreadable JUnit output: {e}"); sys.exit()
total = bad = 0
for case in root.iter("testcase"):
    if case.find("skipped") is not None:
        continue
    total += 1
    if case.find("failure") is not None or case.find("error") is not None:
        bad += 1
if total == 0:
    print(f"fail no tests ran (exit {rc})")
elif bad:
    print(f"fail {bad} of {total} tests failed (exit {rc})")
elif rc != 0:
    print(f"fail GUT exited {rc} with {total} passing tests")
else:
    print(f"pass {total} tests passed")
PY
}

if [ ! -f "$agent_test" ]; then
    msg="$agent_test_rel not found"
    record extra_reference_passes fail "$msg"
    for n in "${mutants[@]}"; do record "extra_mutant_${n}_caught" fail "$msg"; done
else
    outcome=$(run_suite reference)
    echo "reference: $outcome"
    if [ "${outcome%% *}" = pass ]; then
        record extra_reference_passes pass "$outcome"
    else
        record extra_reference_passes fail "tests must pass on the reference Weapon: $outcome"
    fi
    for n in "${mutants[@]}"; do
        outcome=$(run_suite "mutant_$n" "$mutants_dir/$n.patch")
        echo "mutant $n: $outcome"
        if [ "${outcome%% *}" = pass ]; then
            record "extra_mutant_${n}_caught" fail "tests did not catch mutant $n ($outcome)"
        else
            record "extra_mutant_${n}_caught" pass "mutant $n caught: $outcome"
        fi
    done
fi

# Merge into hidden.xml: keep the existing test cases, append one per check.
python3 - "$out_dir/hidden.xml" "$results" <<'PY'
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

hidden, results = Path(sys.argv[1]), Path(sys.argv[2])
checks = [line.split("\t", 2) for line in results.read_text().splitlines() if line]
problem = None
if hidden.is_file():
    try:
        root = ET.parse(hidden).getroot()
    except ET.ParseError as e:
        root, problem = None, f"hidden.xml from the GUT run is unreadable: {e}"
else:
    root, problem = None, "hidden.xml from the GUT run is missing"
if root is None:
    root = ET.Element("testsuites", name="GutTests")
    checks.append(["extra_hidden_xml_present", "fail", problem])
if root.tag != "testsuites":
    wrapper = ET.Element("testsuites", name="GutTests")
    wrapper.append(root)
    root = wrapper

suite = ET.SubElement(root, "testsuite", name="score_extra")
failures = 0
for name, status, message in checks:
    case = ET.SubElement(suite, "testcase", name=name, classname="score_extra",
                         status="pass" if status == "pass" else "fail")
    if status != "pass":
        failures += 1
        ET.SubElement(case, "failure", message=message).text = message
suite.set("tests", str(len(checks)))
suite.set("failures", str(failures))
ET.ElementTree(root).write(hidden, encoding="UTF-8", xml_declaration=True)
for name, status, message in checks:
    print(f"{name}: {status} ({message})")
PY
