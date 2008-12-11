#!/bin/sh

TESTS=`find test -name test\*.rb -print`

if [ -n "${TESTS}" ]; then
	echo
else
	echo "No tests found!"
	exit 1
fi

for TEST in $TESTS; do
	echo "Working on test: $TEST"
	echo
	ruby $TEST
	echo
done
