# 安装vscode
sudo apt install -y code

# 安装nodejs nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
source ~/.bashrc
nvm install node

## node 安装 n8n gemini-cli claude-code
npm install -g n8n
npm install -g @google/gemini-cli
npm install -g @anthropic-ai/claude-code

# 下载 anydesk
sudo dpkg -i anydesk.deb
# 下载 todesk
sudo dpkg -i todesk.deb
# 下载皎月连

# 安装 btop
sudo apt install btop
# 安装 nvtop
sudo add-apt-repository ppa:quentiumyt/nvtop
sudo apt update
sudo apt install nvtop
