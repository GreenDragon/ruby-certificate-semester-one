#!/bin/sh

LOGDIR=logs

utility() {
	SEARCH=`which $1 2>/dev/null`
	if [ -z "${SEARCH}" ]; then
		echo
		echo "No $1 utility found"
		echo
		exit 1
	fi
}

utility tee
utility find
utility cut
utility date

TESTS=`find test -name test\*.rb -maxdepth 1 -print`

if [ -n "${TESTS}" ]; then
	echo
else
	echo "No tests found!"
	exit 1
fi

if [ ! -d $LOGDIR ]; then
	echo
	echo "Making log directory"
	echo
	mkdir $LOGDIR
else
	rm $LOGDIR/*log
fi

for TEST in $TESTS; do
	DATE=`date +%Y.%m.%d.%H.%M.%S`
	TEST_NAME=`echo $TEST | cut -d\/ -f2`
	echo
	if [ -s ${TEST} ]; then
		echo "[$DATE]: Working on test: $TEST"
		echo
		ruby $TEST 2>&1 | tee ${LOGDIR}/${TEST_NAME}.${DATE}.log
	else
		echo "[$DATE]: Skipping zero size test: $TEST"
	fi
	echo
done
