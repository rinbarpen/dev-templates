# ~/.config/fish/functions/proxy_off.fish

function proxy_off
    # 清除HTTP和HTTPS代理
    set -e HTTP_PROXY
    set -e HTTPS_PROXY
    set -e http_proxy
    set -e https_proxy

    # 清除FTP代理
    set -e FTP_PROXY
    set -e ftp_proxy

    # 清除SOCKS代理 (如果设置了ALL_PROXY)
    set -e ALL_PROXY
    set -e all_proxy

    # 清除不走代理的地址
    set -e NO_PROXY
    set -e no_proxy

    echo "❌ 代理已关闭"
end