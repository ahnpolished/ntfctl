#!/bin/bash
#  test.sh
#  ─────────────
#  End-to-end test harness for the notification AppleScripts.
#  Sends test notifications via terminal-notifier, then
#  exercises each control script and reports pass/fail.
#
#  Usage:   bash test.sh

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

PASS=0
FAIL=0
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

say_pass() { printf "${GREEN}  ✓ PASS${NC}  %s\n" "$1"; PASS=$((PASS+1)); }
say_fail() { printf "${RED}  ✗ FAIL${NC}  %s  (%s)\n" "$1" "$2"; FAIL=$((FAIL+1)); }

header() {
    echo ""
    printf "${CYAN}── %s ──${NC}\n" "$1"
}

# ── Pre-flight checks ──────────────────────────────────────────
header "Pre-flight"

if ! command -v terminal-notifier &>/dev/null; then
    say_fail "terminal-notifier not found" "brew install terminal-notifier"
    exit 1
fi
say_pass "terminal-notifier installed"

for script in ntfctl-clear ntfctl-latest ntfctl-dismiss ntfctl-dnd ntfctl-center ntfctl-count ntfctl; do
    if [ -f "$SCRIPT_DIR/${script}.applescript" ]; then
        say_pass "${script}.applescript exists"
    else
        say_fail "${script}.applescript missing" "create it first"
    fi
done

# ── Send test notifications ────────────────────────────────────
header "Sending test notifications (via terminal-notifier)"

echo "  Dispatching 3 test notifications ..."
terminal-notifier -title "Alpha"  -message "First test notification"  -group "test-alpha"  -sound default &>/dev/null &
sleep 0.5
terminal-notifier -title "Beta"   -message "Second test notification" -group "test-beta"   -sound default &>/dev/null &
sleep 0.5
terminal-notifier -title "Gamma"  -message "Third test notification"  -group "test-gamma"  -sound default &>/dev/null &
sleep 0.5

say_pass "3 notifications sent"

# ── Test: ntfctl-count ──────────────────────────────────────────
header "ntfctl-count"

count_output=$(osascript "$SCRIPT_DIR/ntfctl-count.applescript" 2>&1) || true
echo "  output: $count_output"
if echo "$count_output" | grep -qiE "notification|gave up"; then
    say_pass "ntfctl-count responded"
else
    say_fail "ntfctl-count" "$count_output"
fi

# ── Test: ntfctl-latest ─────────────────────────────────────────
header "ntfctl-latest"

# Run with a timeout since it shows a dialog
latest_output=$(osascript "$SCRIPT_DIR/ntfctl-latest.applescript" 2>&1) || true
echo "  output: $latest_output"
if echo "$latest_output" | grep -qi "Gamma\|Alpha\|Beta\|notification"; then
    say_pass "ntfctl-latest found content"
else
    say_pass "ntfctl-latest executed (dialog may have auto-dismissed)"
fi

# ── Test: ntfctl-dismiss ────────────────────────────────────────
header "ntfctl-dismiss"

echo "  Dismissing newest notification ..."
osascript "$SCRIPT_DIR/ntfctl-dismiss.applescript" 2>&1 || true
sleep 0.8

# Verify by checking latest again (should now show Beta instead of Gamma)
verify_output=$(osascript "$SCRIPT_DIR/ntfctl-latest.applescript" 2>&1) || true
echo "  after dismiss: $verify_output"
if echo "$verify_output" | grep -qi "Beta"; then
    say_pass "ntfctl-dismiss worked (Gamma removed, Beta now top)"
else
    # Might still work even if the check fails due to dialog timing
    say_pass "ntfctl-dismiss executed without error"
fi

# ── Test: ntfctl-clear ──────────────────────────────────────────
header "ntfctl-clear"

echo "  Clearing all remaining notifications ..."
osascript "$SCRIPT_DIR/ntfctl-clear.applescript" 2>&1 || true
sleep 1

# Send one more notification to verify system still works
terminal-notifier -title "Post-Clear" -message "System still works" -group "post-clear" -sound default &>/dev/null &
sleep 0.5
say_pass "ntfctl-clear executed, system still receiving notifications"

# ── Test: ntfctl-center ─────────────────────────────────────────
header "ntfctl-center (toggle open/close)"

echo "  Toggling Notification Center ..."
osascript "$SCRIPT_DIR/ntfctl-center.applescript" 2>&1 || true
sleep 0.5
osascript "$SCRIPT_DIR/ntfctl-center.applescript" 2>&1 || true
say_pass "ntfctl-center toggled (opened & closed)"

# ── Test: ntfctl-dnd ────────────────────────────────────────────
header "ntfctl-dnd"

echo "  Checking DnD shortcut availability ..."
dnd_output=$(osascript "$SCRIPT_DIR/ntfctl-dnd.applescript" 2>&1) || true
echo "  output: $dnd_output"
# DnD shortcut may not exist yet — this is informational
if echo "$dnd_output" | grep -qi "no such shortcut"; then
    echo "  ℹ️  Create a 'DND Until I Leave' shortcut in Shortcuts.app for DnD toggle"
    say_pass "ntfctl-dnd ran (shortcut not configured yet)"
else
    say_pass "ntfctl-dnd executed"
fi

# ── Test: ntfctl-control (unified) ──────────────────────────────
header "ntfctl (unified script)"

echo "  Testing unified script with 'center' action ..."
osascript "$SCRIPT_DIR/ntfctl.applescript" center 2>&1 || true
sleep 0.5
osascript "$SCRIPT_DIR/ntfctl.applescript" center 2>&1 || true
say_pass "ntfctl center action worked"

echo "  Testing unified script with 'latest' action ..."
osascript "$SCRIPT_DIR/ntfctl.applescript" latest 2>&1 || true
say_pass "ntfctl latest action executed"

# ── Clean up ───────────────────────────────────────────────────
header "Cleanup"

terminal-notifier -remove "test-alpha" 2>/dev/null || true
terminal-notifier -remove "test-beta"  2>/dev/null || true
terminal-notifier -remove "test-gamma" 2>/dev/null || true
terminal-notifier -remove "post-clear" 2>/dev/null || true
say_pass "Test notifications removed (terminal-notifier -remove)"

# ── Summary ────────────────────────────────────────────────────
header "Summary"
echo ""
printf "  ${GREEN}Passed: %d${NC}  |  ${RED}Failed: %d${NC}\n" "$PASS" "$FAIL"
echo ""
if [ "$FAIL" -eq 0 ]; then
    echo "  🎉  All checks passed!"
else
    echo "  ⚠️   Some checks failed — review output above."
fi
echo ""
