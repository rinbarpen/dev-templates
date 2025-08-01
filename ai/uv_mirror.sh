#!/bin/bash
# uv镜像源管理脚本
# 支持清华、中科大、阿里、南京大学的pip源
# 使用方法：
#   临时使用源: ./uv_mirror.sh <源名称> <uv命令>
#   设置全局源: ./uv_mirror.sh --global <源名称>
#   恢复默认: ./uv_mirror.sh --reset
#   查看当前源: ./uv_mirror.sh --show
#   查看帮助: ./uv_mirror.sh --help

# 定义镜像源映射
declare -A MIRROR_SOURCES
MIRROR_SOURCES["tsinghua"]="https://pypi.tuna.tsinghua.edu.cn/simple"
MIRROR_SOURCES["ustc"]="https://pypi.mirrors.ustc.edu.cn/simple"
MIRROR_SOURCES["aliyun"]="https://mirrors.aliyun.com/pypi/simple"
MIRROR_SOURCES["nju"]="https://mirror.nju.edu.cn/pypi/web/simple"

# 定义源名称映射
declare -A SOURCE_NAMES
SOURCE_NAMES["tsinghua"]="清华大学"
SOURCE_NAMES["ustc"]="中科大"
SOURCE_NAMES["aliyun"]="阿里云"
SOURCE_NAMES["nju"]="南京大学"

# uv配置文件路径
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    # Windows
    UV_CONFIG_DIR="$APPDATA/uv"
else
    # Linux/macOS
    UV_CONFIG_DIR="$HOME/.config/uv"
fi
UV_CONFIG_FILE="$UV_CONFIG_DIR/uv.toml"

# 显示帮助信息
show_help() {
    echo "uv镜像源管理脚本"
    echo "使用方法:"
    echo "  临时使用源: $0 <源名称> <uv命令>"
    echo "  设置全局源: $0 --global <源名称>"
    echo "  恢复默认: $0 --reset"
    echo "  查看当前源: $0 --show"
    echo "  查看帮助: $0 --help"
    echo ""
    echo "支持的源名称:"
    echo "  tsinghua  - 清华大学镜像源"
    echo "  ustc      - 中科大镜像源"
    echo "  aliyun    - 阿里云镜像源"
    echo "  nju       - 南京大学镜像源"
    echo ""
    echo "示例:"
    echo "  # 临时使用清华源安装包"
    echo "  $0 tsinghua pip install requests"
    echo "  $0 tsinghua sync"
    echo ""
    echo "  # 设置全局源"
    echo "  $0 --global tsinghua"
    echo ""
    echo "  # 查看当前配置"
    echo "  $0 --show"
}

# 创建uv配置目录
create_config_dir() {
    if [[ ! -d "$UV_CONFIG_DIR" ]]; then
        mkdir -p "$UV_CONFIG_DIR"
        echo "已创建uv配置目录: $UV_CONFIG_DIR"
    fi
}

# 临时使用镜像源
temp_mirror() {
    local source_name="$1"
    shift  # 移除第一个参数，剩下的是uv命令
    
    if [[ -z "${MIRROR_SOURCES[$source_name]}" ]]; then
        echo "错误: 不支持的源名称 '$source_name'"
        echo "支持的源: tsinghua, ustc, aliyun, nju"
        return 1
    fi
    
    if [[ $# -eq 0 ]]; then
        echo "错误: 请提供uv命令"
        echo "示例: $0 tsinghua pip install requests"
        return 1
    fi
    
    local mirror_url="${MIRROR_SOURCES[$source_name]}"
    local source_display_name="${SOURCE_NAMES[$source_name]}"
    
    echo "临时使用 $source_display_name 镜像源: $mirror_url"
    echo "执行命令: uv $@"
    echo ""
    
    # 使用环境变量临时设置镜像源
    UV_INDEX_URL="$mirror_url" uv "$@"
}

# 设置全局镜像源
set_global_mirror() {
    local source_name="$1"
    if [[ -z "${MIRROR_SOURCES[$source_name]}" ]]; then
        echo "错误: 不支持的源名称 '$source_name'"
        echo "支持的源: tsinghua, ustc, aliyun, nju"
        return 1
    fi
    
    local mirror_url="${MIRROR_SOURCES[$source_name]}"
    local source_display_name="${SOURCE_NAMES[$source_name]}"
    
    create_config_dir
    
    echo "正在设置uv全局镜像源为: $source_display_name ($mirror_url)"
    
    # 创建或更新uv配置文件
    cat > "$UV_CONFIG_FILE" << EOF
[pip]
index-url = "$mirror_url"

[tool.uv.pip]
index-url = "$mirror_url"
EOF
    
    echo "uv全局镜像源设置完成！"
    echo "配置文件位置: $UV_CONFIG_FILE"
}

# 重置为默认源
reset_mirror() {
    if [[ -f "$UV_CONFIG_FILE" ]]; then
        rm "$UV_CONFIG_FILE"
        echo "已删除uv配置文件，恢复为默认源"
        echo "删除的文件: $UV_CONFIG_FILE"
    else
        echo "uv配置文件不存在，已经是默认源"
    fi
}

# 显示当前配置
show_current() {
    echo "当前uv配置:"
    echo "配置文件: $UV_CONFIG_FILE"
    
    if [[ -f "$UV_CONFIG_FILE" ]]; then
        echo "配置内容:"
        cat "$UV_CONFIG_FILE"
        echo ""
        
        # 尝试识别当前使用的源
        local current_url=$(grep 'index-url' "$UV_CONFIG_FILE" | head -1 | sed 's/.*= *"\(.*\)"/\1/')
        for source in "${!MIRROR_SOURCES[@]}"; do
            if [[ "$current_url" == "${MIRROR_SOURCES[$source]}" ]]; then
                echo "当前全局源: ${SOURCE_NAMES[$source]} 镜像源"
                return
            fi
        done
        echo "当前全局源: 自定义镜像源"
    else
        echo "未找到配置文件，使用默认源 (https://pypi.org/simple)"
    fi
    
    echo ""
    echo "环境变量:"
    if [[ -n "$UV_INDEX_URL" ]]; then
        echo "UV_INDEX_URL=$UV_INDEX_URL (临时覆盖)"
    else
        echo "UV_INDEX_URL 未设置"
    fi
}

# 验证uv是否安装
check_uv() {
    if ! command -v uv &> /dev/null; then
        echo "错误: 未找到uv命令，请先安装uv"
        echo "安装方法: curl -LsSf https://astral.sh/uv/install.sh | sh"
        exit 1
    fi
}

# 检查是否为有效的源名称
is_valid_source() {
    local source_name="$1"
    [[ -n "${MIRROR_SOURCES[$source_name]}" ]]
}

# 主逻辑
case "$1" in
    "--global")
        check_uv
        if [[ -z "$2" ]]; then
            echo "错误: 请指定要设置的源名称"
            show_help
            exit 1
        fi
        set_global_mirror "$2"
        ;;
    "--reset")
        reset_mirror
        ;;
    "--show")
        show_current
        ;;
    "--help")
        show_help
        ;;
    "")
        echo "错误: 请提供参数"
        show_help
        exit 1
        ;;
    *)
        # 检查第一个参数是否为有效的源名称
        if is_valid_source "$1"; then
            # 临时使用镜像源
            check_uv
            if [[ -z "$2" ]]; then
                echo "错误: 请提供uv命令"
                show_help
                exit 1
            fi
            source_name="$1"
            shift  # 移除源名称参数
            temp_mirror "$source_name" "$@"
        else
            echo "错误: 无效的参数或源名称 '$1'"
            show_help
            exit 1
        fi
        ;;
esac