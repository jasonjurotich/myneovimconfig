### INSTALL BREW
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && brew update
(that will install xcode command line tools as well)

brew upgrade && brew upgrade --cask
brew search --casks

### INSTALL XCODE AND MAS
Xcode is over 7 GB and take about 90 minutes to download and install
open and accept permisions
then brew install --build-from-source mas
then in Xcode, under Locations, choose command line tools and choose Xcode 12.3
That will allow you to install mas
but then it is still killed

NOT NEEDED IF YOU GO INTO XCODE MENTIONED ABOVE. 
** if you install brew BEFORE xcode, you MUST run this BEFORE installing mas: 
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

doing that MAS is still killed

(mas is broken on M1 for now)
mas list
mas search Xcode
mas install 808809998
mas purchase 768053424
mas outdated
mas upgrade
mas upgrade 715768417
mas signin mas@example.com
mas signin --dialog mas@example.com
mas signin mas@example.com 'appleidpass'

### INSTALL APPS
brew upgrade && brew upgrade --cask && brew install git gcc authy node mosh postgresql wget miniforge Boop iterm2 && brew install --HEAD pyenv && brew install --HEAD pyenv-virtualenv && pyenv install -v 3.9.1 && brew install --HEAD luajit && brew install --HEAD neovim && npm -g install typescript && npm i -S @types/google-apps-script && npm install -g @google/clasp && npm -g install eslint prettier eslint-config-prettier eslint-plugin-prettier && npm audit fix && sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" && chsh -s /bin/zsh && mkdir -p .config/nvim && curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && git clone https://github.com/jasonjurotich/myneovimconfig && cd ~/myneovimconfig && cat alias.txt >> ~/.oh-my-zsh/custom/aliases.zsh && cd && echo 'eval "$(pyenv init -)"' >> ~/.zshrc && echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc && source ~/.zshrc && cp ~/myneovimconfig/init.vim ~/.config/nvim/init.vim

** IF you use pyenv, use pyenv global 3.9.1 or pyenv local 3.9.1
** You can install notion from brew, but does not install the M1 version, go to website instead.
** Install Chrome Intel, then extensions, then delete Chrome Intel, and install Chrome M1

### CONFIGURE PYTHON
wget -c https://github.com/apple/tensorflow_macos/releases/download/v0.1alpha0/tensorflow_macos-0.1alpha0.tar.gz && tar -xvf tensorflow_macos-0.1alpha0.tar.gz && cd tensorflow_macos/arm64 && conda create -n tf24 && conda init zsh 

reboot iterm

** you MUST check the versions of what is downloaded from github or there will be an error. 

cd tensorflow_macos/arm64 && conda activate tf24 && conda install -y python==3.8.6 && pip install --upgrade pip && conda install -y pandas matplotlib scikit-learn jupyterlab scipy pillow scikit-learn && pip install --force pip==20.2.4 wheel setuptools cached-property six && pip install --upgrade --no-dependencies --force numpy-1.18.5-cp38-cp38-macosx_11_0_arm64.whl grpcio-1.33.2-cp38-cp38-macosx_11_0_arm64.whl h5py-2.10.0-cp38-cp38-macosx_11_0_arm64.whl tensorflow_addons-0.11.2+mlcompute-cp38-cp38-macosx_11_0_arm64.whl && pip install absl-py astunparse flatbuffers gast google_pasta keras_preprocessing opt_einsum protobuf tensorflow_estimator termcolor typing_extensions wrapt wheel tensorboard typeguard && pip install --upgrade --force --no-dependencies tensorflow_macos-0.1a0-cp38-cp38-macosx_11_0_arm64.whl && pip install wheel jedi neovim pylint Pygments six asyncio asyncpg joblib selenium unicodedata2 requests-html beautifulsoup4 multiprocess httplib2 django flask aiogram google-api-python-client google_auth_oauthlib google_spreadsheet py-cpuinfo glances python-telegram-bot scrapy scrapy-selenium matplotlib pretty_html_table psycopg2 python-telegram-bot google-api-python-client "ipython[all]" google_auth_oauthlib wheel setuptools cached-property six audiotsm

