#!/bin/bash
# Double-click to stop the background server (started via TicketingLauncher.app).

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PID_FILE="$ROOT/.ticketing_server.pid"
PORT="${PORT:-5000}"

if [[ -f "$PID_FILE" ]]; then
  PID="$(cat "$PID_FILE")"
  if kill -0 "$PID" 2>/dev/null; then
    kill "$PID" && rm -f "$PID_FILE" && echo "Stopped server (PID $PID)." || echo "Could not stop PID $PID."
    exit 0
  fi
  rm -f "$PID_FILE"
fi

# Fallback: kill whatever is listening on the port
PIDS=$(lsof -tiTCP:"${PORT}" -sTCP:LISTEN 2>/dev/null || true)
if [[ -n "$PIDS" ]]; then
  echo "$PIDS" | xargs kill 2>/dev/null && echo "Stopped process on port ${PORT}." || echo "Could not stop process on port ${PORT}."
else
  echo "No server found (port ${PORT})."
fi
read -r _
