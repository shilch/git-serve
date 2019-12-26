#!/bin/sh

# Setup test repository
mkdir -p /tmp/testrepo
cd /tmp/testrepo

git config --global user.name "Nobody"
git config --global user.email "nobody@nobody.com"

git init
echo "This is a test" > myfile.txt
git add myfile.txt
git commit -m "First commit"

GIT_REPOSITORY='/tmp/testrepo/.git' /var/scripts/entrypoint.sh &
ENTRYPOINT_PID=$!

# Test - Entrypoint starts up successfully
RETRIES=10
while true; do
	sleep 2

	COMM=$(ps -o pid,comm | grep "^\s*${ENTRYPOINT_PID} " | awk '{ print $2 }')

	if [ -z "${COMM}" ] || [ "$COMM" == "nginx" ]; then
		break
	fi

	if [ $RETRIES -eq 0 ]; then
		echo "Too many retries" >&2
		exit 1
	fi
	RETRIES=$((RETRIES-1))

	echo "Entrypoint didn't fail or run nginx yet, waiting for another 2 seconds."
done

if [ -z "${COMM}" ]; then
	wait ${ENTRYPOINT_PID}
	echo "Entrypoint script exited with code" $? >&2
	exit 1
fi

# Test - Can fetch myfile.txt
wget -q -O - http://localhost/myfile.txt | grep "This is a test"
if ! [ $? -eq 0 ]; then
	echo "Failed to fetch myfile.txt" >&2
	exit 1
fi

# Test - Update
echo "This is a second test" > myfile.txt
git add myfile.txt
git commit -m "Second commit"

if ! wget -q -O - http://localhost/git-serve-update; then
	echo "Calling git-serve-update failed" >&2
	exit 1
fi

wget -q -O - http://localhost/myfile.txt | grep "This is a second test"
if ! [ $? -eq 0 ]; then
	echo "Failed to fetch updated myfile.txt" >&2
	exit 1
fi

# Cleanup
kill $ENTRYPOINT_PID
exit 0
