#!/bin/bash

find . -name \*~ | xargs rm
tar zcf homework.tgz week*