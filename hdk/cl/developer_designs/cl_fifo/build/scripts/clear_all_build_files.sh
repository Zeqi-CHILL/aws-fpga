#!/bin/bash

# Check current build directory size
SIZE_BEFORE=$(du -sk ../../build/ | cut -f1)

# Delete files
rm -rf ../checkpoints/
rm -rf ../constraints/cl_clocks_aws.xdc
rm -rf ../reports/
rm -rf .Xil/
rm -f *.nohup.out
rm -f *.vivado.log
rm -f awsver.txt
rm -rf hd_visual/
rm -f last_log

# Check current build directory size again
SIZE_AFTER=$(du -sk ../../build/ | cut -f1)
DIFFERENCE=$(( ($SIZE_BEFORE - $SIZE_AFTER) / 1024 ))

echo "Cleared about $DIFFERENCE MB."
