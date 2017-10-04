#!/usr/bin/env bash
set -e
ansible-playbook -i hosts launch.yml -K
