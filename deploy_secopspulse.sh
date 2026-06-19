#!/bin/bash
cd ~/SecOpsPulse

echo "=== SecOpsPulse Deployment Script ==="
echo "Setting up sudo permissions temporarily..."

# Configure sudo to not require password for this session
echo 'Utsav@1234' | sudo -S bash -c "echo 'utsav ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ansible-temp"

if [ $? -eq 0 ]; then
    echo "✓ Sudo configured successfully"
    
    echo "Running Ansible playbook..."
    ansible-playbook -i inventory.ini deploy_audit.yml -v
    
    echo "Cleaning up sudo configuration..."
    sudo rm -f /etc/sudoers.d/ansible-temp
    
    if [ -f /var/www/html/index.html ]; then
        echo "✓ Deployment successful!"
        echo "Dashboard available at: http://localhost/"
        echo "Report also saved to: /tmp/security_report.html"
    else
        echo "⚠ Deployment may have issues, check the logs above"
    fi
else
    echo "✗ Failed to configure sudo"
    exit 1
fi