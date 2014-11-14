# VNC role

## Install

- Launch ubuntu instance with public IP and in SSH accessible security group
- Add instance to inventory under remote-vnc group
- Run ansible playbook (will prompt for a VNC password)

## Usage

- Set up VNC tunnel over SSH `ssh ubuntu@[remote_ip] -L 5901/127.0.0.1/5901`
- Connect with VNC client to vnc://127.0.0.1:5091
- Enter prompted password from ansible playbook run
