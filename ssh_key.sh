# 生成 ssh key
menlist = ["sxy", "rinbarpen"]
for i in menlist:
    ./ssh_keygen.sh $i -N ""
echo "ssh key 已生成"
# 提示用户手动添加 ssh key 到 ssh agent
echo "请手动将生成的 ssh key 添加到你的机器"