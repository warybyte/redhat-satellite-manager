#!/bin/bash
#
# This hammer command will sync channels specified in your Satellite. This is NOT ALL THE CHANNELS.
# To get an exhaustive list of channels, run the following and append accordingly
#
# $ hammer repository list --organization-label=1
#
ORG_ID=1;

###################################################
# sync server repos (example)
###################################################
echo "Syncronizing server repos";
sleep 5;
echo "";

for ORG_REPO in $(hammer repository list --organization-id=$ORG_ID --product 'Red Hat Enterprise Linux Server' | awk -F ' ' '{print $1}' | grep -v "-" | grep -v "ID");
do
        echo "Start: "$(date);
        hammer repository synchronize --id $ORG_REPO;
        echo "Stop: "$(date);
done
