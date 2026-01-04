#!/bin/bash
# Set environment variable for BrentTimeKeeper
# Run this once, or add to your shell profile for persistence

launchctl setenv TIMEKEEPER_LOG_PATH "~/scripts/CB-Workspace/brent-workspace/ob-notes/Brent Notes/Dashboard/Daily/WORK-LOG.md"

echo "TIMEKEEPER_LOG_PATH set for GUI apps"
echo "Restart BrentTimeKeeper for changes to take effect"
