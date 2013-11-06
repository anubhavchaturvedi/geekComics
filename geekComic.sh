#!/bin/bash
dir=$HOME/Pictures/GEEK_COMIC

    if [ -f "$dir" ]; then
        echo "$dir is a file";
	exit 1;
    elif [ ! -d "$dir" ]; then
        mkdir -p $dir
	echo "DIRECTORY CREATED  ::  $dir"
    fi

n=$RANDOM
n=`echo "$n % 3" | bc`

if [ $n -eq 0 ]
then
	# Fetch xkcd strip
	wget -q -O $dir/pageSource 'http://dynamic.xkcd.com/random/comic/';
	imageLink=$(grep -o '\ http://imgs.xkcd.com/comics/[a-zA-Z0-9_.]*.png' $dir/pageSource);
	imageName=`echo $imageLink | grep -o "[a-zA-Z0-9_]*.png"`;
elif [ $n -eq 1 ]
then
	# fetch Cyanide & Happiness strip
	wget -q -O $dir/pageSource 'http://www.explosm.net/comics/random/';
	imageLink=$(grep -o 'http://www.explosm.net/db/files/Comics/[A-Za-z0-9/]*.png' $dir/pageSource);
        imageName=`echo $imageLink | grep -o "[a-zA-Z0-9_]*.png"`;
elif [ $n -eq 2 ]
then
	# fetch PhD Comics strip
        wget -q -O $dir/pageSource 'http://phdcomics.com/comics.php';
        imageLink=$(grep -o 'src=http://www.phdcomics.com/comics/archive/[A-Za-z0-9_]*.gif' $dir/pageSource | grep -P -o 'http://www.phdcomics.com/comics/archive/[A-Za-z0-9_]*.gif');
        imageName=`echo $imageLink | grep -o "[a-zA-Z0-9_]*.gif"`;
fi


if [ ! -f "$dir/$imageName" ]; then
	echo "Fetching Image";
	wget -q -O $dir/$imageName $imageLink;
fi
rm $dir/pageSource
eog $dir/$imageName & disown
