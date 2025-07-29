sudo apt install -y git curl wget build-essential neovim fish

sudo apt install -y ssh openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh
# 修改SSH端口为2345
sudo sed -i 's/#Port 22/Port 2345/' /etc/ssh/sshd_config
sudo systemctl restart ssh

sudo apt install -y vsftpd
sudo systemctl enable vsftpd
sudo systemctl start vsftpd
# 修改FTP端口为8021
sudo sed -i 's/#listen_port=21/listen_port=8021/' /etc/vsftpd.conf
sudo systemctl restart vsftpd

# 添加nvidia-drivers源
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt update

# miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh

cp MACDVPN.json ~/.config/MACDVPN/config.json
# cp ~/.bashrc ~/.bashrc.bak
# cp ./.bashrc ~/.bashrc
# 给bash添加 huggingface 镜像 和 cuda 环境
echo "export HF_ENDPOINT=https://hf-mirror.com" >> ~/.bashrc
echo "export CUDA_HOME=/usr/local/cuda" >> ~/.bashrc
echo "export PATH=$CUDA_HOME/bin:$PATH" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH" >> ~/.bashrc

source ~/.bashrc
# cp ~/.config/fish/config.fish ~/.config/fish/config.fish.bak
# mv ./config.fish ~/.config/fish/config.fish
# 给fish添加 huggingface 镜像 和 cuda 环境 和 uv 镜像
# 设置 huggingface 镜像
set -gx HF_ENDPOINT https://hf-mirror.com

# 设置 CUDA 环境变量
set -gx CUDA_HOME /usr/local/cuda
set -gx PATH $CUDA_HOME/bin $PATH
set -gx LD_LIBRARY_PATH $CUDA_HOME/lib64 $LD_LIBRARY_PATH
source ~/.config/fish/config.fish

# conda 安装 py310环境。pip安装pytorch，cudatoolkit
conda install -n py310 -c nvidia -c pytorch \
    python=3.10 \
    -y
conda activate py310
pip install torch==2.4.0 torchvision==0.19.0 torchaudio==2.4.0 --index-url https://download.pytorch.org/whl/cu124

# 测试 torch是否支持cuda，命令行
python -c "import torch; print(torch.cuda.is_available()); print(torch.version.cuda); print(torch.backends.cudnn.is_available())"
# 安装uv从官网
curl -sSL https://astral.sh/uv/install.sh | sh

# 安装vscode
sudo apt install -y code

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

# 安装nodejs nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
source ~/.bashrc
nvm install node

## node 安装 n8n gemini-cli claude-code
npm install -g n8n
npm install -g @google/gemini-cli
npm install -g @anthropic-ai/claude-code

# # 下载 anydesk
# sudo dpkg -i anydesk.deb
# # 下载 todesk
# sudo dpkg -i todesk.deb
# # 下载皎月连

# chsh -s /usr/bin/fish
