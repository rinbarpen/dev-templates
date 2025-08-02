#!/usr/bin/bash
name="$1"
remote_user="$2"
remote_ip="$3"
if [ -z "$remote_user" ] || [ -z "$remote_ip" ]; then
  disable_send=false
else
  disable_send=true
fi

if [ -z "$name" ]; then
  echo "用法: $0 <name> [remote_user] [remote_ip]"
  exit 1
fi

targetMachine="4090-ubuntu2404"
now=$(date +"%Y-%m-%d_%H-%M-%S")
comment="$name $now"
keyPath="$HOME/.ssh/ssh_${targetMachine}_${name}"

ssh-keygen -t ed25519 -C "$comment" -N "" -f $keyPath

if [ "$disable_send" = false ]; then
  mv "${keyPath}" ./
else
  scp "${keyPath}" "${remote_user}@${remote_ip}:~/.ssh/"
fi
cat "${keyPath}.pub" >> "$HOME/.ssh/authorized_keys"
