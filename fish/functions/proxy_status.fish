# ~/.config/fish/functions/proxy_status.fish

function proxy_status
    echo "--- 代理状态 ---"
    if set -q HTTP_PROXY
        echo "HTTP_PROXY   : $HTTP_PROXY"
    end
    if set -q HTTPS_PROXY
        echo "HTTPS_PROXY  : $HTTPS_PROXY"
    end
    if set -q http_proxy
        echo "http_proxy   : $http_proxy"
    end
    if set -q https_proxy
        echo "https_proxy  : $https_proxy"
    end
    if set -q FTP_PROXY
        echo "FTP_PROXY    : $FTP_PROXY"
    end
    if set -q ALL_PROXY
        echo "ALL_PROXY    : $ALL_PROXY"
    end
    if set -q NO_PROXY
        echo "NO_PROXY     : $NO_PROXY"
    end

    if not set -q HTTP_PROXY; and not set -q HTTPS_PROXY; and not set -q ALL_PROXY
        echo "当前没有设置代理环境变量。"
    end
    echo "----------------"
end