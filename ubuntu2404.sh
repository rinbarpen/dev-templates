sudo apt install -y git curl wget build-essential neovim fish net-tools

sudo apt install -y ssh
sudo cp sshd_config /etc/ssh/sshd_config
sudo systemctl start ssh

sudo apt install -y vsftpd
sudo cp vsftpd.conf /etc/vsftpd/vsftpd.conf
sudo systemctl start vsftpd

# 安装nvidia-drivers后需要锁定内核版本！！！

cp MACDVPN.json ~/.config/MACDVPN/config.json

# 从官网安装 uv
curl -sSL https://astral.sh/uv/install.sh | sh

./bash.sh
./fish.sh

# conda 安装 py310环境。pip安装pytorch，cudatoolkit
conda install -n py310 -c nvidia -c pytorch \
    python=3.10 \
    -y
conda activate py310
pip install torch==2.4.0 torchvision==0.19.0 torchaudio==2.4.0 --index-url https://download.pytorch.org/whl/cu124

# 测试 torch是否支持cuda，命令行
python -c "import torch; print(torch.cuda.is_available()); print(torch.version.cuda); print(torch.backends.cudnn.is_available())"

# 安装docker
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker run hello-world
sudo systemctl enable docker
sudo systemctl start docker


