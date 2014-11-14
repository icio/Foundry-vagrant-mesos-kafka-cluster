#!/bin/bash 

sed -e 's/"/\\"/g' -e '/^\s*$/d' -e 's/^/"/g' -e 's/$/\\n",/g' $1
