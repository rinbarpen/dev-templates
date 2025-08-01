cp ~/.config/fish/config.fish ~/.config/fish/config.fish.bak
# 给fish添加 huggingface 镜像 和 uv 镜像 和 cuda 环境
# 设置 huggingface 镜像
set -gx HF_ENDPOINT https://hf-mirror.com
# 设置 uv 镜像
set -gx UV_ENDPOINT https://mirrors.nju.edu.cn/pypi/web/simple
# 设置 CUDA 环境变量
set -gx CUDA_HOME /usr/local/cuda
set -gx PATH $CUDA_HOME/bin $PATH
set -gx LD_LIBRARY_PATH $CUDA_HOME/lib64 $LD_LIBRARY_PATH

cp -r functions/ ~/.config/fish/functions

exec fish
