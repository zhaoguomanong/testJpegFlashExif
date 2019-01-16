#!/bin/bash

which jhead > /dev/null 2>&1

if [ $? != 0 ];then
    sudo apt-get install -y jhead
fi


photos=()
photos=$(find . -name "*.jpg")

failed=0
count=0
failedList=()
for photo in $(echo -ne "$photos")
do
    photoName=$(echo "$photo" | sed 's/\.\///g')
    ((count++))
    flashStatus=$(jhead ${photo}  \
    | grep -iE 'Flash used' \
    | awk -F ':' '{print $2}' \
    | sed 's/ //g')
    echo "$flashStatus" | grep -iE 'No' > /dev/null 2>&1
    if [ $? = 0 ];then
        failedList[$failed]="$photoName"
        ((failed++))
    fi
    echo "$photoName ---> $flashStatus"

done

echo "photo amount = $count, failed num = $failed"


echo "======[failed List as below]======"
for failedItem in ${failedList[@]}
do
    echo "$failedItem"
done


