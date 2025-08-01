#!/usr/bin/bash
name="$1"
serv_user="$2"
serv_ip="$3"
if [ -z "$name" ] || [ -z "$serv_user" ] || [ -z "$serv_ip" ]; then
  echo "用法: $0 <name> <serv_user> <serv_ip>"
  exit 1
fi

targetMachine="4090-ubuntu2404"
now=$(date +"%Y-%m-%d_%H-%M-%S")
comment="$name $now"
keyPath="$HOME/.ssh/ssh_${targetMachine}_${name}"

ssh-keygen -t ed25519 -C "$comment" -N "" -f $keyPath

mv "${keyPath}" "$HOME/.ssh/"
ssh-copy-id "${keyPath}.pub" "${serv_user}@${serv_ip}"
