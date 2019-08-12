#
# This script runs smoothly on Redhat 7.7 OS, Redhat Satellite version 6.3 - 6.5. Simply insert your Content View (CV) names
# and it will parse the rest of the data needed to publish a new CV version, promote to associated Life-cycle environment,
# then clean up older versions of the CV.
#
#!/bin/bash
for CV_NAME in $(echo <CV1> <CV2> ... <CVn>)
do
        ## Defining vars
        ORG_ID="1";
        LC_ENV_NUM=$(hammer lifecycle-environment list --organization-id $ORG_ID | grep $CV_NAME | sed s/" "/,/g | awk -F ',' '{print $1}' | tail -1);

        for CV_NUM in $(hammer content-view list --organization-id $ORG_ID | grep $CV_NAME | sed s/" "/,/g | awk -F ',' '{print $1}' | tail -1);
        do
                ## publish new content-view
                echo "Publishing CV ID $CV_NAME";
                hammer content-view publish --id $CV_NUM --organization-id $ORG_ID;
                echo "";

                ## promote CV to environment
                echo "Promoting to LifeCycle environment";
                CV_LATEST=$(hammer content-view version list --content-view-id $CV_NUM --organization-id $ORG_ID | grep CV | awk -F ' ' '{print $1}' | head -1);
                echo "This is the latest version of $CV_NAME - $CV_LATEST";
                hammer content-view version promote --content-view-id $CV_NUM --id $CV_LATEST --to-lifecycle-environment -id $LC_ENV_NUM --organization-id $ORG_ID;
                echo "";

                ## remove oldest content view
                echo "Removing oldest CV ID";
                CV_OLDEST=$(hammer content-view version list --content-view-id $CV_NUM --organization-id $ORG_ID | grep CV | awk -F ' ' '{print $1}' | tail -1);
                echo "This is the oldest version of $CV_NAME - $CV_OLDEST";
                hammer content-view version delete --content-view-id $CV_NUM --id $CV_OLDEST --organization-id $ORG_ID;
                echo "";
        done
done
