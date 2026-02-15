#!/bin/bash
# exit on error
set -e
#Makes scripts fully automated
#Prevents them from stopping mid-way
#Ensures provisioning can run without manual intervention
# for example it prevents from asking questions like : Do you want to continue? [Y/n]
export DEBIAN_FRONTEND=noninteractive
# Fetches the latest package information from Debian repositories.
# -y answer directly questions by yes 
apt update -y
apt upgrade -y
# cron schedule recurrent jobs 
# rsyslog records events 
apt install -y \
  sudo \
  ufw \
  curl \
  cron \   
  rsyslog
