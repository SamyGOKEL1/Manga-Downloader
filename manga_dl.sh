#!/bin/bash
url=$1
chapter=$2
name=$3
status=0
current_image=1
num_error=10

if [ $1 == "-h" ]
then
    echo "USAGE"
    echo "  ./manga_dl.sh arg1 arg2 arg3"
    echo "      arg1 anime-sama url to get image"
    echo "      arg2 chapter number"
    echo "      targ3 name of the manga"
    exit 0
fi

if [ ! -d "./$name" ]
then
    mkdir "./$name"
fi

# DOWNLOAD IMAGE
while [ $num_error -ne 0 ]
do
    date=$(date +%s%N)
    status=$(curl -s -o /dev/null -w "%{http_code}" "$url/$chapter/$current_image.jpg")
    echo "$url/$chapter/$current_image.jpg"
    echo $status
    if ((status == 404 || status == 522))
    then
        num_error=$(( $num_error - 1 ))
    else
        curl "$url/$chapter/$current_image.jpg" > "./$name/$date.jpg"
	echo "./$name/$date.jpg"
    fi
    current_image=$(( $current_image + 1 ))
done
# GENERATE PDF
img2pdf ./$name/*.jpg -o ./$name/$name-$chapter.pdf
rm ./$name/*.jpg
