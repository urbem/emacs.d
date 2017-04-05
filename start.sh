#!/usr/bin/env bash
# locate
test -f /var/db/locate.database || sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist


# virtual envs
mkdir  ~/.virtualenvs
mkdir /tmp/emacs

declare -a arr=('furion' 'sven' 'docker-dd-agent-java' 'sange' 'ddserver' 'jakiro')
for i in "${arr[@]}"; do
    test -d "$HOME/.virtualenvs/$i" || virtualenv --system-site-packages "$HOME/.virtualenvs/$i"
done


brew install shellcheck ispell chezscheme
sudo pip install jedi autopep8 flake8 isort pylint
easy_install Sphinx

which vmd || cnpm install -g vmd

# if flycheck has configparser import error, try uninstall it and install again
# sudo pip uninstall configparser && pip install configparser


# ananconda mode error:
# sudo pip install -U setuptools

# ananconda jump error
# check python config


# echo "heje"
