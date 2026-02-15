#!/bin/bash
set -e

ufw allow 1111/tcp
ufw --force enable
