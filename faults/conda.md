## 安装包时，时不时会报 Segmentation fault (core dumped)
删除从不使用的包
```bash
conda clean --packages
```
删除tar包
```bash
conda clean --tarballs
```
删除索引缓存、锁定文件、未使用过的包和tar包
```bash
conda clean –a
```
