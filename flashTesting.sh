#!/bin/bash

which jhead > /dev/null 2>&1

if [ $? != 0 ];then
    sudo apt-get install -y jhead
fi

photoPath="$1"

if [ -z "$photoPath" ] || [ ! -d "$photoPath" ] ;then
    photoPath="."
fi


photos=()
photos=$(find "$photoPath" -name "*.jpg")

failed=0
count=0
failedList=()
for photo in $(echo -ne "$photos")
do
    photoName=$(basename "$photo")
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
if [ "$count" != 0 ];then
    failedRate=$(echo "$failed" "$count" \
    | awk '{printf ("%.2f\n", 100*$1/$2)}')
else
    failedRate="0"
fi

echo "photo amount = $count, failed num = $failed, failed rate = $failedRate%"


echo "======[failed List as below]======"
for failedItem in ${failedList[@]}
do
    echo "$failedItem"
done


