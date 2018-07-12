#! /bin/sh

# Copyright 2018 (c) Peter Fontaine <peter.fontaine@reactiva.fr>
# Copyright 2018 (c) SAS Reactiva Software
#
#
# Permission is hereby granted, free of charge, to any person obtaining 
# a copy of this software and associated documentation files (the “Software”),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the 
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# The Software is provided “as is”, without warranty of any kind, express or
# implied, including but not limited to the warranties of merchantability,
# fitness for a particular purpose and noninfringement. In no event shall
# the authors or copyright holders be liable for any claim, damages or other
# liability, whether in an action of contract, tort or otherwise, arising
# from, out of or in connection with the software or the use or other
# dealings in the Software.

echo '-- Launching Dolibarr\n'
echo '   Docker version maintained by Peter Fontaine <peter.fontaine@reactiva.fr>\n'
echo '   https://www.reactiva.fr\n\n'

# Hook prestart
if [ ! -z $(HOOK_PRESTART) ]; then
	curl -L $(HOOK_PRESTART) -o hookprestart.sh
	chmod +x hookprestart.sh

	echo "-- Launching pre start hook"
	exec hookprestart.sh
fi

# Verify if dolibarr is installed

echo '-- Check if Dolibarr is installed\n'

if [ -f "/dolibarr/htdocs/conf/conf.php" ]; then
	echo "Dolibarr is installed"

	echo "Check for update"
	if [ ! $(DOL_VERSION) = `cat /dolibarr/documents/install.lock` ]; then

		# Check for pre install hook
		if [ ! -z $(HOOK_PREUPDATE) ]; then
			curl -L $(HOOK_PREUPDATE) -o hookprestart.sh
			chmod +x hookpreupdate.sh

			echo "-- Launching preupdate hook"
			exec hookpreupdate.sh
		fi

		exec update.sh

		# Check for pre install hook
		if [ ! -z $(HOOK_POSTUPDATE) ]; then
			curl -L $(HOOK_POSTUPDATE) -o hookprestart.sh
			chmod +x hookpostupdate.sh

			echo "-- Launching postupdate hook"
			exec hookpostupdate.sh
		fi

		rm /dolibarr/documents/install.lock
		echo $(DOL_VERSION) > /dolibarr/documents/install.lock

		echo "Dolibarr update complete"
	fi
else
	# Check for pre install hook
	if [ ! -z $(HOOK_PREINSTALL) ]; then
		curl -L $(HOOK_PREINSTALL) -o hookprestart.sh
		chmod +x hookpreinstall.sh

		echo "-- Launching preinstall hook"
		exec hookpreinstall.sh
	fi

	exec install.sh

	# Check for post install hook
	if [ ! -z $(HOOK_POSTINSTALL) ]; then
		curl -L $(HOOK_POSTINSTALL) -o hookprestart.sh
		chmod +x hookpostinstall.sh

		echo "-- Launching postinstall hook"
		exec hookpostinstall.sh
	fi

	echo $(DOL_VERSION) > /dolibarr/documents/install.lock
	chmod 444 /dolibarr/documents/install.lock

	echo "Dolibarr install complete"
fi

# check if hook for entrypoint prelaunch is present
if [ ! -z $(HOOK_PRELAUNCH) ]; then
	curl -L $(HOOK_PRELAUNCH) -o hookprestart.sh
	chmod +x hookprelaunch.sh

	echo "-- Launching prelaunch hook"
	exec hookprelaunch.sh
fi

echo '-- Ready to launch\n'

# launch apache service
exec /usr/bin/httpd start

# launch cron service
exec /usr/bin/crond start

if [ ! -f "/dolibarr/documents/dolibarr.log" ]; then
	echo "" > /dolibarr/documents/dolibarr.log
fi

# show real-time log

tail -f /dolibarr/documents/dolibarr.log
