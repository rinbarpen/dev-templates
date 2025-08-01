sudo apt install -y git curl wget build-essential neovim fish net-tools

sudo apt install -y ssh
sudo cp ./ssh/sshd_config /etc/ssh/sshd_config
sudo systemctl start ssh

sudo apt install -y vsftpd
sudo cp ./ftp/vsftpd.conf /etc/vsftpd/vsftpd.conf
sudo systemctl start vsftpd

# 安装nvidia-drivers后需要锁定内核版本！！！

cp MACDVPN.json ~/.config/MACDVPN/config.json

# 从官网安装 uv
curl -sSL https://astral.sh/uv/install.sh | sh

# bash
./bash/bash.sh
# fish
./fish.sh

# ai
./ai/miniconda.sh
./ai/docker.sh

# software
./softwares.sh

# dmesg
