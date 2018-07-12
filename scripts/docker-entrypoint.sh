#!/bin/sh

echo '-- Launching Dolibarr\n'
echo '   Docker version maintained by Peter Fontaine <peter.fontaine@reactiva.fr>\n'
echo '   https://www.reactiva.fr\n\n'

# check if hook for entrypoint prestart is present

echo '-- Looking for prestart hook\n'

# Verify if dolibarr is installed

echo '-- Check if Dolibarr is installed\n'

# check if hook for entrypoint preinstall is present

echo '-- Looking for preinstall hook\n'

# if not install

install.sh

# check if hook for entrypoint postinstall is present

echo '-- Looking for postinstall hook\n'

# if installed verify update

echo '-- Check Dolibarr installed version\n'

# check if hook for entrypoint preupdate is present

echo '-- Looking for preupdate hook\n'

update.sh

# check if hook for entrypoint postupdate is present

echo '-- Looking for postupdate hook\n'

# check if hook for entrypoint poststart is present

echo '-- Looking for poststart hook\n'

echo '-- We are ready to launch\n'
# launch apache service
# launch cron service
# show log