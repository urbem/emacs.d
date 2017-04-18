#!/usr/bin/env bash
# locate
test -f /var/db/locate.database || sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist

# virtual envs
mkdir ~/.virtualenvs
mkdir /tmp/emacs

declare -a arr=('furion' 'sven' 'docker-dd-agent-java' 'sange' 'ddserver' 'jakiro')
for i in "${arr[@]}"; do
	test -d "$HOME/.virtualenvs/$i" || virtualenv --system-site-packages "$HOME/.virtualenvs/$i"
done

sudo pip install jedi autopep8 flake8 isort pylint rope ropemacs

install_pymacs() {
	rm -rf v0.25 pinard-Pymacs-*
	wget https://github.com/pinard/Pymacs/zipball/v0.25
	unzip v0.25
	cd pinard-Pymacs-*
	make
	python setup.py build
	python setup.py install
	mkdir -p ~/.emacs.d/site-lisp/pymacs/
	cp pymacs.el ~/.emacs.d/site-lisp/pymacs/
	cd ..
	rm -rf v0.25 pinard-Pymacs-*

}

pip show pymacs || install_pymacs

# if flycheck has configparser import error, try uninstall it and install again
# sudo pip uninstall configparser && pip install configparser

# ananconda mode error:
# sudo pip install -U setuptools

# ananconda jump error
# check python config
