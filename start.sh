#!/usr/bin/env bash



pip install jedi


# locate
test -f /var/db/locate.database || sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
