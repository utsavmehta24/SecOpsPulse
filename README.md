# SecOpsPulse

**Repository:** [github.com/utsavmehta24/SecOpsPulse](https://github.com/utsavmehta24/SecOpsPulse)

<!--
SecOpsPulse deploys a local Nginx-hosted security dashboard with Ansible.
The project audits the target Linux host, renders dashboard.html.j2, and serves it from /var/www/html/index.html.
Use this README as the source of truth for the current workspace files and supported run commands.
-->

SecOpsPulse is a small Ansible project that audits a Linux host and publishes a local security dashboard at `http://localhost/`.

It collects system facts, open ports, installed package counts, firewall status, resource usage, and network interface data. Each dashboard card includes a **View Details** panel that explains the current status, what the data indicates, why it is useful, and what to review next — so operators and clients can understand the report without leaving the page.

## Project Files

| File | Purpose |
| --- | --- |
| `deploy_audit.yml` | Main Ansible playbook. Installs required packages, gathers audit data, renders the dashboard, and starts Nginx. |
| `dashboard.html.j2` | Jinja2 HTML template for the dashboard served as `/var/www/html/index.html`. |
| `inventory.ini` | Local Ansible inventory targeting `localhost` through the local connection. |
| `requirements.txt` | Optional Python package requirements for pip-based Ansible/Jinja setups. |
| `deploy_secopspulse.sh` | Linux/WSL helper script that runs the playbook from the project folder. |

## Requirements

- **Ubuntu** (native Linux) or **WSL2 with Ubuntu** (Windows)
- Python 3
- Ansible
- Sudo access on the target host

Native Windows Ansible is not supported. Windows users must run SecOpsPulse through **WSL2 (Ubuntu)**.

## Install

Clone the repository:

```bash
git clone https://github.com/utsavmehta24/SecOpsPulse.git
cd SecOpsPulse
```

### On Ubuntu (native Linux)

Install system dependencies:

```bash
sudo apt update
sudo apt install -y ansible python3-pip nginx curl net-tools iproute2
```

Optional Python dependencies (useful for pip-based Ansible setups):

```bash
python3 -m pip install -r requirements.txt
```

### On Windows (via WSL2)

1. Install [WSL2 with Ubuntu](https://learn.microsoft.com/en-us/windows/wsl/install) if you have not already.
2. Open **Ubuntu** from the Start menu (or run `wsl` in PowerShell).
3. Inside WSL, install dependencies:

```bash
sudo apt update
sudo apt install -y ansible python3-pip nginx curl net-tools iproute2
```

Optional Python dependencies:

```bash
python3 -m pip install -r requirements.txt
```

Keep the project in a folder WSL can access, for example:

```text
/mnt/c/Users/ADMIN/SecOpsPulse
```

Or clone directly inside WSL:

```bash
git clone https://github.com/utsavmehta24/SecOpsPulse.git ~/SecOpsPulse
cd ~/SecOpsPulse
```

## Run

Enter your sudo password when prompted. The dashboard will be available at `http://localhost/` after a successful run.

### On Ubuntu (native Linux)

From the project directory:

```bash
chmod +x deploy_secopspulse.sh
./deploy_secopspulse.sh
```

Or run the playbook directly:

```bash
ansible-playbook -i inventory.ini deploy_audit.yml -K
```

Open the dashboard in your browser:

```text
http://localhost/
```

### On Windows (via WSL2)

SecOpsPulse runs inside WSL, not in PowerShell directly. Use one of the following options.

**Option 1 — From Ubuntu (WSL) terminal (recommended)**

```bash
cd ~/SecOpsPulse
chmod +x deploy_secopspulse.sh
./deploy_secopspulse.sh
```

If the project is on your Windows drive, use the WSL path:

```bash
cd "/mnt/c/Users/ADMIN/OneDrive/Desktop/Ansible Project/SecOpsPulse"
chmod +x deploy_secopspulse.sh
./deploy_secopspulse.sh
```

**Option 2 — From Windows PowerShell**

```powershell
wsl bash -lc "cd '/mnt/c/Users/ADMIN/OneDrive/Desktop/Ansible Project/SecOpsPulse' && bash deploy_secopspulse.sh"
```

Adjust the path if you cloned the repository to a different folder on your machine.

When prompted for **BECOME password**, enter your **WSL Ubuntu user password** (the same password you use for `sudo` inside WSL).

Open the dashboard in your Windows browser:

```text
http://localhost/
```

The dashboard file is generated inside WSL at:

```text
/var/www/html/index.html
```

### What to expect during deployment

- **Gathering Facts** can take 20–30 seconds on WSL; that is normal.
- Package installation skips `apt update` to avoid long hangs on WSL; required packages are installed from the existing cache.
- You will be prompted once for your sudo password (`-K` / `--ask-become-pass`).

## Validate

Run these commands from Ubuntu or inside WSL on Windows.

Check playbook syntax:

```bash
ansible-playbook -i inventory.ini deploy_audit.yml --syntax-check
```

Check that Nginx is serving the dashboard:

```bash
curl -I http://localhost/
curl -s http://localhost/ | grep SecOpsPulse
```

Re-run only the dashboard and web tasks after template changes:

```bash
ansible-playbook -i inventory.ini deploy_audit.yml --tags web -K
```

## What The Dashboard Shows

- **System Information**: Hostname, operating system, kernel, architecture, and uptime.
- **Network Security**: Listening ports and firewall status.
- **Package Information**: Package manager type and installed package count.
- **Resource Utilization**: CPU cores, load average, memory capacity, and memory usage.
- **Security Status**: Summary compliance indicators generated from the current audit.
- **Network Interfaces**: Interface IPv4 addresses and default gateway.

Click **View Details** on any card to expand a detailed analysis panel with:

- **Current status** — a live summary of what the host is reporting right now
- **Field guide** — what each metric means in plain language
- **What this indicates** — how to interpret the result
- **Why it's useful** — operational and security value of the data
- **Recommended actions** — practical next steps to review

## Notes

- This is a local visibility tool, not a vulnerability scanner.
- The compliance score is a simple dashboard indicator, not a formal compliance certification.
- Re-run the playbook whenever you want to refresh the report with current system data.
- To audit a remote host instead of localhost, update `inventory.ini` with the target host and connection settings.

## Support

- Email: utsavmehta24072003@gmail.com
- Issues: [GitHub Issues](https://github.com/utsavmehta24/SecOpsPulse/issues)
- Documentation: [Wiki](https://github.com/utsavmehta24/SecOpsPulse/wiki)
- Discussions: [GitHub Discussions](https://github.com/utsavmehta24/SecOpsPulse/discussions)
