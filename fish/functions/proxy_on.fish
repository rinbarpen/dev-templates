# ~/.config/fish/functions/proxy_on.fish

function proxy_on
    # 定义代理地址 (请根据你的实际情况修改)
    # 你也可以通过参数传入，例如：proxy_on socks5://127.0.0.1:1080
    set -l PROXY_ADDR "$argv[1]"
    if test -z "$PROXY_ADDR"
        set PROXY_ADDR "http://127.0.0.1:18080" # 默认代理地址
    end

    # 设置HTTP和HTTPS代理
    set -gx HTTP_PROXY "$PROXY_ADDR"
    set -gx HTTPS_PROXY "$PROXY_ADDR"
    set -gx http_proxy "$PROXY_ADDR"
    set -gx https_proxy "$PROXY_ADDR"

    # 设置FTP代理 (如果需要)
    #set -x FTP_PROXY "$PROXY_ADDR"
    #set -x ftp_proxy "$PROXY_ADDR"

    # 设置SOCKS代理 (如果你的代理是SOCKS5，也可以用ALL_PROXY)
    set -gx ALL_PROXY "socks5://127.0.0.1:1080"
    set -gx all_proxy "socks5://127.0.0.1:1080"

    # 设置不走代理的地址，包括本地地址
    set -x NO_PROXY "localhost,127.0.0.1,::1"
    set -x no_proxy "localhost,127.0.0.1,::1"

    echo "✅ 代理已开启：$PROXY_ADDR"
    echo "   (不走代理：$NO_PROXY)"
end