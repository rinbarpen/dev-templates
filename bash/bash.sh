cp ~/.bashrc ~/.bashrc.bak
# 给bash添加 huggingface 镜像 和 cuda 环境 和 uv 镜像
# 设置 huggingface 镜像
echo "export HF_ENDPOINT=https://hf-mirror.com" >> ~/.bashrc
# 设置 uv 镜像
echo "export UV_DEFAULT_INDEX=https://mirrors.nju.edu.cn/pypi/web/simple" >> ~/.bashrc
# 设置 CUDA 环境变量
echo "export CUDA_HOME=/usr/local/cuda" >> ~/.bashrc
echo "export PATH=$CUDA_HOME/bin:$PATH" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH" >> ~/.bashrc

cp ./.bash_functions ~/.bash_functions
echo """
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi
""" >> ~/.bashrc

source ~/.bashrc