#!/usr/bin/env bash
# locate
test -f /var/db/locate.database || sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist


# virtual envs
mkdir  ~/.virtualenvs

declare -a arr=('furion' 'sven' 'docker-dd-agent-java' 'sange' 'ddserver' 'jakiro')
for i in "${arr[@]}"; do
    test -d "$HOME/.virtualenvs/$i" || virtualenv --system-site-packages "$HOME/.virtualenvs/$i"
done


brew install shellcheck ispell
sudo pip install jedi autopep8 flake8 isort
