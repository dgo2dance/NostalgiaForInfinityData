



## env environment

Create the virtual environment in current directory called 'env':

Terminal

python3.10 -m venv env
Activate the virtual environment:

Terminal

# For bash/zsh/etc.
source env/bin/activate

# For fish
source env/bin/activate.fish
Upgrade pip to the latest version:

Terminal

pip install -U pip
Install requirements with pip

## install
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

pip install -r backtest_requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

