#!/bin/bash
# Double-click this in Finder to start the app (macOS).
# Terminal opens here; close the window or Ctrl+C to stop the server.
#
# To open the browser without this Terminal window, use TicketingLauncher.app
# (double-click that instead). It runs the server in the background and opens the browser.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT" || exit 1

if [[ -x "$ROOT/venv/bin/python" ]]; then
  exec "$ROOT/venv/bin/python" "$ROOT/app.py"
fi
if command -v python3 >/dev/null 2>&1; then
  exec python3 "$ROOT/app.py"
fi
if command -v python >/dev/null 2>&1; then
  exec python "$ROOT/app.py"
fi

echo "Could not find Python. Create a venv in the project folder or install python3."
read -r _
