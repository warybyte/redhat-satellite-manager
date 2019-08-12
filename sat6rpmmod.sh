#!/bin/bash
#
# Lists out RPMs that have been modified (updated by Sync for example) by date
#
udate= <INSERT DATE> # "Mar 7" for example
ppath=/var/lib/pulp/content/units/rpm/
uos= <INSERT OS> # "el6" for example

for j in $(sudo ls -al $ppath | grep $udate | awk -F ' ' '{print $9}'); 
do 
  for h in $(sudo ls -al $ppath/$j | grep $udate | awk -F ' ' '{print $9}');
  do 
    sudo ls -al $ppath/$j/$h | grep $udate | grep rpm | grep $uos;
  done; 
done
