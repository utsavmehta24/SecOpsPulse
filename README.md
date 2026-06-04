DevSecOps Local Host Security Compliance Auditor

An automated, production-grade Ansible tool that transforms configuration management into a real-time security auditing pipeline. It scans local host machine metrics, parses network vulnerability vectors (open ports, firewall policies), and uses Jinja2 templating to compile a browser-accessible live compliance dashboard via Nginx.

🛠️ System Architecture & Mechanics

This project shifts away from static configurations. It acts as an Infrastructure-as-Code (IaC) and Policy-as-Compliance agent:

1. Audit Phase: Executes live system calls ("ufw", "ss", "dpkg") to capture actual machine state.
2. State Registration: Registers raw command outputs into dynamic Ansible variables.
3. Remediation Phase: Enforces Nginx installation, cleans up non-compliant default files, and tightens web-root permissions.
4. Dynamic Reporting: Compiles a custom dashboard template ("dashboard.html.j2") by injecting real-time system metrics.
5. Gated Validation: Runs automated post-deployment integration tests to assert filesystem and HTTP network readiness.

---

📂 Project Structure

Ensure your workspace directory looks exactly like this before initiating deployment:

ansible-security-audit/
├── README.md               # Documentation and execution blueprint
├── inventory.ini           # Targeted host definitions (localhost)
├── dashboard.html.j2       # Dynamic Jinja2 audit reporting engine
├── deploy_audit.yml        # Core infrastructure execution playbook
└── test_compliance.yml     # Compulsory automated post-deployment assertion tests

📦 Component Breakdown

1. Host Inventory ("inventory.ini")

Configures Ansible to run safely inside a localized, non-destructive sandbox targeting your native environment.

[target_host]
localhost ansible_connection=local

2. Core Deployment & Audit Playbook ("deploy_audit.yml")

The orchestration engine. Uses administrative escalation ("become: yes") to interface securely with underlying operating system network sockets and package caches.

3. Automated Post-Deployment Verification ("test_compliance.yml")

A mandatory testing gate. It ensures the environment didn't fail silently by executing:

- Filesystem Verification: Verifies the physical presence of the rendered dashboard in "/var/www/html/".
- HTTP Payload Assertions: Actively calls "http://localhost/" via an internal URI module and checks for context-specific security strings to validate that Nginx is parsing configurations flawlessly.

🚀 Execution Sequence

To prevent configuration errors, execute the playbooks strictly in the following sequence from inside the "ansible-security-audit" folder.

Step 1: Pre-Flight Syntax Validation Gate

Run syntax diagnostics across both infrastructure layers. If any YAML indentations or parameters are malformed, the validation fails immediately before making system modifications.

ansible-playbook -i inventory.ini deploy_audit.yml --syntax-check
ansible-playbook -i inventory.ini test_compliance.yml --syntax-check

Step 2: Main Infrastructure Provisioning & Audit

Execute the primary deployment engine. The "-K" flag is mandatory, prompting Ansible for your system sudo password to authorize package synchronization and network surface querying.

ansible-playbook -i inventory.ini deploy_audit.yml -K

Step 3: Compulsory Compliance State Verification

Trigger the test play to execute the end-to-end integration assertions against the active web service.

ansible-playbook -i inventory.ini test_compliance.yml

📊 Viewing the Compliance Output

Once all tasks return "ok" and "changed" with zero failures, launch any browser and navigate to your localized host:

http://localhost/

The resulting dashboard displays an immutable audit summary, tracking kernel configurations, open network sockets, total package surface metrics, and generation timestamps mapped directly from your machine's hardware and operating system state.
