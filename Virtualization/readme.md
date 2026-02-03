#  First Secure Server Setup (Debian)
This document describes step by step the complete configuration of a secure Linux server, compliant with the project requirements:
system, users, SSH, firewall, password policy, sudo, monitoring script, and service deployment.

##  System Installation

OS Choice

==>Debian Stable (latest)
==>Minimal installation (no graphical interface)

## Hostname Configuration

sudo hostnamectl set-hostname myname
==> Verification:  hostname

##  System Update
```bash
sudo apt update && sudo apt upgrade -y
```
## Non-root User Creation
```bash
sudo adduser new-name
```
Add the user to the sudo group:
```bash
sudo usermod -aG sudo new-name
```

Verification
```bash
groups new-name
```
## Secure SSH Configuration

Install SSH :
```bash
sudo apt install openssh-server -y
```

Configuration
Edit the file:
```bash
sudo nano /etc/ssh/sshd_config
```

Modify :
```bash
Port 1111
PermitRootLogin no
PasswordAuthentication yes
```

Restart SSH:
```bash
sudo systemctl restart ssh
```

Verification
```bash
ss -tulnp | grep 1111
```
6️⃣ Firewall Configuration (UFW)

Installation
```bash
sudo apt install ufw -y
```

Rules
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 1111/tcp
sudo ufw enable
```

Verification
```bash
sudo ufw status
```
## Strong Password Policy

### Objectives
Expiration: 30 days
Minimum change interval: 2 days
Warning: 7 days
Length ≥ 10 characters
Uppercase + lowercase + number
No more than 3 identical consecutive characters
Must not contain the username
7 characters different from the previous password

login.defs Configuration
```bash
sudo nano /etc/login.defs
```

Modify:
```bash
PASS_MAX_DAYS 30
PASS_MIN_DAYS 2
PASS_WARN_AGE 7
```

### PAM Configuration 
is how Linux decides who is allowed to log in, how they authenticate, and under what rules (password strength, expiration, retries, etc.).

Install the module:
```bash
sudo apt install libpam-pwquality -y
```
Edit:
```bash
sudo nano /etc/pam.d/common-password
```

Replace the line with:
```bash
password requisite pam_pwquality.so retry=3 minlen=10 ucredit=-1 lcredit=-1 dcredit=-1 maxrepeat=3 usercheck=1 difok=7
```
## Secure sudo Configuration

Objectives
Maximum 3 attempts
Custom error message
Full logging (input/output)

Create log directory
```bash
sudo mkdir /var/log/sudo
sudo chmod 700 /var/log/sudo
```

sudoers Configuration
```bash
sudo visudo
```

Add:

Defaults passwd_tries=3
Defaults badpass_message="⚠️ Access denied: incorrect password"
Defaults logfile="/var/log/sudo/sudo.log"
Defaults log_input
Defaults log_output

## Monitoring Script (monitoring.sh)

Script creation
```bash
sudo nano /usr/local/bin/monitoring.sh
```

Content
```bash
#!/bin/bash

ARCH=$(uname -a)
CPU_PHYS=$(lscpu | grep "Socket(s)" | awk '{print $2}')
CPU_VIRT=$(nproc)
RAM=$(free -m | awk '/Mem:/ {printf "%d/%dMB (%.2f%%)", $3, $2, $3/$2*100}')
DISK=$(df -h --total | awk '/total/ {printf "%s/%s (%s)", $3, $2, $5}')
CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | awk '{printf "%.1f%%", 100-$8}')
LAST_BOOT=$(who -b | awk '{print $3 " " $4}')
TCP=$(ss -ta | grep ESTAB | wc -l)
USERS=$(who | wc -l)
IP=$(hostname -I | awk '{print $1}')
MAC=$(ip link | grep ether | awk '{print $2}' | head -n1)
SUDO=$(grep COMMAND /var/log/sudo/sudo.log | wc -l)

wall << EOF
#Architecture: $ARCH
#CPU physical : $CPU_PHYS
#vCPU : $CPU_VIRT
#Memory Usage: $RAM
#Disk Usage: $DISK
#CPU load: $CPU_LOAD
#Last boot: $LAST_BOOT
#Connections TCP : $TCP ESTABLISHED
#User log: $USERS
#Network: IP $IP ($MAC)
#Sudo : $SUDO cmd
Your Server your rules !
EOF
```

Permissions
```bash
sudo chmod +x /usr/local/bin/monitoring.sh
```
🔟 Cron Configuration

Edit root crontab:
```bash
sudo crontab -e
```

Add:
```bash
@reboot /usr/local/bin/monitoring.sh
*/10 * * * * /usr/local/bin/monitoring.sh
```
## Service Deployment: Nginx

Installation
```bash
sudo apt install nginx -y
```

Service management
```bash
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
sudo systemctl status nginx
```

Test
```bash
curl localhost
```

Expected result

Welcome to nginx!


📌 Accessibility
Accessible only from inside the VM (port 80 not opened in UFW).

📝 Challenges Encountered

PAM configuration was tricky → solved using official documentation

sudo log permissions → fixed with chmod 700

Monitoring script errors → removed by properly handling command outputs

✅ Final Checklist

Debian Stable

Correct hostname

SSH on port 1111, root login disabled

Firewall configured

Non-root user created

Strong password policy enforced

Secure and logged sudo

monitoring.sh working

Cron active

Service deployed

🎉 Server ready — secure, monitored, and compliant with professional standards.
