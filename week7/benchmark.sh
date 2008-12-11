#!/bin/bash

STEPS="1 2 3 4 5 6 7 8 9 10"
echo $STEPS

rm benchmark.log

for step in ${STEPS}; do
	echo "Step: $step"
	time ruby test/*rb 2>&1 | tee -a benchmark.log
done
