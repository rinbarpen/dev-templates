# miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
mkdir ~/miniconda3
mv Miniconda3-latest-Linux-x86_64.sh ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh
rm ~/miniconda3/miniconda.sh
source ~/miniconda3/bin/activate
conda init --all
