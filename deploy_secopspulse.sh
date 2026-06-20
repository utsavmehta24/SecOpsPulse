#!/usr/bin/env bash
# SecOpsPulse deployment helper.
# Runs the main Ansible playbook from this script's directory.
# Keeps sudo password handling inside Ansible's normal -K prompt instead of storing secrets in the repo.
# Prints the dashboard URL after a successful deployment.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=== SecOpsPulse Deployment ==="
echo "Enter your WSL user password when prompted."
echo "Gathering Facts can take 20-30 seconds on WSL; that is normal."
echo "Package install skips apt update to avoid long WSL hangs."
ansible-playbook -i inventory.ini deploy_audit.yml -K

echo
echo "Deployment complete."
echo "Dashboard: http://localhost/"
