# Automated Virtual Desktop Infrastructure (VDI)
**Engineered by:** Shahied Rustin | Rustin Systems

![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-Automation-EE0000?style=for-the-badge&logo=ansible&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-Scripting-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)

## 📌 Project Overview
This repository contains the Infrastructure-as-Code (IaC) required to provision a bare-metal Linux server into a secure, multi-user Virtual Desktop Infrastructure (VDI). 

Originally architected to support concurrent engineering students requiring remote access to heavy virtualization workloads (VirtualBox/KVM), this deployment bridges the gap between lightweight client machines and enterprise-grade host performance. 

The deployment is fully automated via Ansible, converting a fresh Ubuntu Server installation into an optimized XFCE desktop environment with strict XRDP ingress controls in under 10 minutes.

---

## ⚙️ Key Engineering Features
* **Idempotent Provisioning:** Ansible playbooks handle the complete lifecycle from repository injections (Brave, Oracle) to package installations and configuration locking.
* **Kernel Management:** Automatically purges incompatible kernels and locks the GRUB bootloader to a stable release to ensure hypervisor compatibility and security.
* **Student Image Desktop Cloning:** Utilizes `/etc/skel` to automatically generate standardized, restricted environments (pre-pinned apps, read-only shared directories, custom wallpapers) upon user creation.
* **XRDP Monitor Override:** Custom `.xsession` scripting to bypass the notorious XRDP virtual monitor bug, guaranteeing consistent UI rendering across dynamic RDP sessions.
* **Security Hardening:** Implements UFW (Uncomplicated Firewall) locked to ports 22 and 3389, backed by Fail2ban to automatically block SSH brute-force attempts.
* **CLI Lifecycle Management:** Includes a custom Bash utility (`manage_lab_users.sh`) for rapid, error-free student onboarding and automated group permission assignment.

---

## ⚠️ Disclaimer & Maintenance Notice
This Infrastructure-as-Code (IaC) deployment was engineered and tested specifically for **Ubuntu 24.04 LTS**. 
* **Kernel Pinning:** To ensure strict compatibility with VirtualBox 7.0 at the time of development, this playbook includes a hardcoded task to purge the `6.17.*` kernel line and lock GRUB to the stable `6.8` baseline. As Canonical releases new kernels, or as VirtualBox updates its compatibility matrix, these specific package targets in `setup_node.yml` may need to be manually updated by the maintainer.
* **Provided "As-Is":** This architecture is provided as an open-source reference. Please review the playbook and test in a sandbox environment before deploying to production.

---

## 📚 Extended Documentation
For detailed guides on operating the server and engineering the network ingress, refer to the included documentation:
* [📖 Quick Start Guide](lquickstart.md) - A step-by-step manual for faculty to deploy the server on a local subnet, verify RDP connections, and generate student accounts.
* [ARCHITECTURE](https://github.com/rustinsystems/Automated-Virtual-Desktop-Infrastructure/blob/main/ARCHITECTURE.md) - An advisory brief with details for Enterprise Remote Access options (VLAN, Cloudflare Zero Trust, FRP)

---

## 🚀 Setup & Deployment

### Prerequisites
1. A physical machine or VM running a fresh installation of Ubuntu Server 24.04.
2. An Admin account with `sudo` privileges and OpenSSH installed.
3. Ansible installed on your local control node.

### Deployment Steps

1. Clone this repository to your local control node:
```bash
git clone [https://github.com/yourusername/Automated-Virtual-Desktop-Infrastructure.git](https://github.com/yourusername/Automated-Virtual-Desktop-Infrastructure.git)
cd Automated-Virtual-Desktop-Infrastructure
```

2. Update the `hosts.ini` file with your target server's IP address and admin username:

```ini
[lab_servers]
node1 ansible_host=192.168.X.X ansible_user=your_admin_username
```


3. Run the Ansible playbook:
```bash
ansible-playbook -i hosts.ini setup_node.yml -K

```

*(The `-K` flag will prompt you for the remote server's sudo password).*

If the server is configured with a password login:
```bash
ansible-playbook -i hosts.ini setup_node.yml -k -K
```
*(The `-k` flag will prompt you for the remote server's SSH password).*

4. Once the playbook completes successfully, reboot the target server.

---

## 🛠️ Daily Operations: User Management

Once the VDI is deployed, administrators can manage user access via the integrated CLI tool.

Log into the server terminal and execute:

```bash
sudo manage_lab_users

```

**Features:**

* **Add a new user:** Automatically provisions an isolated home directory, assigns virtualization groups (`vboxusers`), clones the Student Image desktop, and generates a default password.
* **Remove a user:** Instantly purges the account and wipes the isolated directory to free up disk space.
* **List active users:** Displays all currently provisioned standard accounts.

---

## 🔒 Security & Ingress

This deployment is designed to sit behind an enterprise firewall or VPN. For networks with strict inbound NAT restrictions, it is highly recommended to pair this deployment with an outbound Zero Trust overlay (such as a **Cloudflare Tunnel** or a **Fast Reverse Proxy (FRP)**) to allow secure remote RDP access without opening edge firewall ports.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](https://www.google.com/search?q=LICENSE) file for details.
