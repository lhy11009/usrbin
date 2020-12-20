#!/bin/bash
echo ${var+x}
var=1
echo ${var+x}
if [ -z ${var+x} ]; then
		echo 1
else
		echo 0
fi
