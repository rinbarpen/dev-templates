#!/bin/bash
# conda镜像源管理脚本
# 支持清华、中科大、阿里、南京大学的conda源
# 使用方法：
#   添加源: ./conda_mirror.sh --add <源名称>
#   移除源: ./conda_mirror.sh --remove <源名称>
#   查看帮助: ./conda_mirror.sh --help

# 定义镜像源映射
declare -A MIRROR_SOURCES
MIRROR_SOURCES["tsinghua"]="https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/ https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/"
MIRROR_SOURCES["ustc"]="https://mirrors.ustc.edu.cn/anaconda/pkgs/main/ https://mirrors.ustc.edu.cn/anaconda/pkgs/free/ https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge/"
MIRROR_SOURCES["aliyun"]="https://mirrors.aliyun.com/anaconda/pkgs/main/ https://mirrors.aliyun.com/anaconda/pkgs/free/ https://mirrors.aliyun.com/anaconda/cloud/conda-forge/"
MIRROR_SOURCES["nju"]="https://mirror.nju.edu.cn/anaconda/pkgs/main/ https://mirror.nju.edu.cn/anaconda/pkgs/free/ https://mirror.nju.edu.cn/anaconda/cloud/conda-forge/"

# 显示帮助信息
show_help() {
    echo "conda镜像源管理脚本"
    echo "使用方法:"
    echo "  添加源: $0 --add <源名称>"
    echo "  移除源: $0 --remove <源名称>"
    echo "  查看帮助: $0 --help"
    echo ""
    echo "支持的源名称:"
    echo "  tsinghua  - 清华大学镜像源"
    echo "  ustc      - 中科大镜像源"
    echo "  aliyun    - 阿里云镜像源"
    echo "  nju       - 南京大学镜像源"
    echo ""
    echo "示例:"
    echo "  $0 --add tsinghua"
    echo "  $0 --remove ustc"
}

# 添加镜像源
add_mirror() {
    local source_name="$1"
    if [[ -z "${MIRROR_SOURCES[$source_name]}" ]]; then
        echo "错误: 不支持的源名称 '$source_name'"
        echo "支持的源: tsinghua, ustc, aliyun, nju"
        return 1
    fi
    
    echo "正在添加 $source_name 镜像源..."
    for url in ${MIRROR_SOURCES[$source_name]}; do
        # 检查是否已存在
        if conda config --show channels | grep -q "$url"; then
            echo "镜像源已存在: $url"
        else
            conda config --add channels "$url"
            echo "已添加镜像源: $url"
        fi
    done
    echo "$source_name 镜像源添加完成！"
}

# 移除镜像源
remove_mirror() {
    local source_name="$1"
    if [[ -z "${MIRROR_SOURCES[$source_name]}" ]]; then
        echo "错误: 不支持的源名称 '$source_name'"
        echo "支持的源: tsinghua, ustc, aliyun, nju"
        return 1
    fi
    
    echo "正在移除 $source_name 镜像源..."
    for url in ${MIRROR_SOURCES[$source_name]}; do
        if conda config --show channels | grep -q "$url"; then
            conda config --remove channels "$url"
            echo "已移除镜像源: $url"
        else
            echo "镜像源不存在: $url"
        fi
    done
    echo "$source_name 镜像源移除完成！"
}

# 主逻辑
case "$1" in
    "--add")
        if [[ -z "$2" ]]; then
            echo "错误: 请指定要添加的源名称"
            show_help
            exit 1
        fi
        add_mirror "$2"
        ;;
    "--remove")
        if [[ -z "$2" ]]; then
            echo "错误: 请指定要移除的源名称"
            show_help
            exit 1
        fi
        remove_mirror "$2"
        ;;
    "--help")
        show_help
        ;;
    *)
        echo "错误: 无效的参数"
        show_help
        exit 1
        ;;
esac
