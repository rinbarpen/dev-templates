#!/bin/bash
# pip镜像源管理脚本
# 支持清华、中科大、阿里、南京大学的pip源
# 使用方法：
#   设置源: ./pip_mirror.sh --set <源名称>
#   恢复默认: ./pip_mirror.sh --reset
#   查看当前源: ./pip_mirror.sh --show
#   查看帮助: ./pip_mirror.sh --help

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

# pip配置文件路径
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    # Windows
    PIP_CONFIG_DIR="$APPDATA/pip"
    PIP_CONFIG_FILE="$PIP_CONFIG_DIR/pip.ini"
else
    # Linux/macOS
    PIP_CONFIG_DIR="$HOME/.pip"
    PIP_CONFIG_FILE="$PIP_CONFIG_DIR/pip.conf"
fi

# 显示帮助信息
show_help() {
    echo "pip镜像源管理脚本"
    echo "使用方法:"
    echo "  设置源: $0 --set <源名称>"
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
    echo "  $0 --set tsinghua"
    echo "  $0 --show"
    echo "  $0 --reset"
}

# 创建pip配置目录
create_config_dir() {
    if [[ ! -d "$PIP_CONFIG_DIR" ]]; then
        mkdir -p "$PIP_CONFIG_DIR"
        echo "已创建pip配置目录: $PIP_CONFIG_DIR"
    fi
}

# 设置镜像源
set_mirror() {
    local source_name="$1"
    if [[ -z "${MIRROR_SOURCES[$source_name]}" ]]; then
        echo "错误: 不支持的源名称 '$source_name'"
        echo "支持的源: tsinghua, ustc, aliyun, nju"
        return 1
    fi
    
    local mirror_url="${MIRROR_SOURCES[$source_name]}"
    local source_display_name="${SOURCE_NAMES[$source_name]}"
    
    create_config_dir
    
    echo "正在设置pip镜像源为: $source_display_name ($mirror_url)"
    
    # 创建pip配置文件
    cat > "$PIP_CONFIG_FILE" << EOF
[global]
index-url = $mirror_url
trusted-host = $(echo $mirror_url | sed 's|https\?://||' | sed 's|/.*||')
EOF
    
    echo "pip镜像源设置完成！"
    echo "配置文件位置: $PIP_CONFIG_FILE"
}

# 重置为默认源
reset_mirror() {
    if [[ -f "$PIP_CONFIG_FILE" ]]; then
        rm "$PIP_CONFIG_FILE"
        echo "已删除pip配置文件，恢复为默认源"
        echo "删除的文件: $PIP_CONFIG_FILE"
    else
        echo "pip配置文件不存在，已经是默认源"
    fi
}

# 显示当前源
show_current() {
    echo "当前pip配置:"
    echo "配置文件: $PIP_CONFIG_FILE"
    
    if [[ -f "$PIP_CONFIG_FILE" ]]; then
        echo "配置内容:"
        cat "$PIP_CONFIG_FILE"
        echo ""
        
        # 尝试识别当前使用的源
        local current_url=$(grep "index-url" "$PIP_CONFIG_FILE" | sed 's/.*= *//')
        for source in "${!MIRROR_SOURCES[@]}"; do
            if [[ "$current_url" == "${MIRROR_SOURCES[$source]}" ]]; then
                echo "当前使用: ${SOURCE_NAMES[$source]} 镜像源"
                return
            fi
        done
        echo "当前使用: 自定义镜像源"
    else
        echo "未找到配置文件，使用默认源 (https://pypi.org/simple)"
    fi
}

# 主逻辑
case "$1" in
    "--set")
        if [[ -z "$2" ]]; then
            echo "错误: 请指定要设置的源名称"
            show_help
            exit 1
        fi
        set_mirror "$2"
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
    *)
        echo "错误: 无效的参数"
        show_help
        exit 1
        ;;
esac