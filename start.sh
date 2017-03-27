#!/usr/bin/env bash



sudo pip install jedi autopep8 flake8

# locate
test -f /var/db/locate.database || sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist


# brew
brew install shellcheck ispell
