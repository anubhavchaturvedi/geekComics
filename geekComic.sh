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
NUM_SOURCES=5
n=`echo "$n % $NUM_SOURCES" | bc`

if [ "$1" != "" ];
then
	if [ $1 -ge 0 ] && [ $1 -lt $NUM_SOURCES ] ;
	then
			n=$1;
	else
		echo "INVALID USAGE : ./geekComic <comic index>";
		exit 1;
	fi
fi

if [ $n -eq 0 ]
then
	# Fetch xkcd strip
	wget -q -O $dir/pageSource 'http://dynamic.xkcd.com/random/comic/';
	imageLink=$(grep -o '\ http://imgs.xkcd.com/comics/[a-zA-Z0-9_.]*.png' $dir/pageSource);
	imageName="XKCD_"`echo $imageLink | grep -o "[a-zA-Z0-9_]*.png"`;
elif [ $n -eq 1 ]
then
	# fetch Cyanide & Happiness strip
	wget -q -O $dir/pageSource 'http://www.explosm.net/comics/random/';
	imageLink=$(grep -o 'http://www.explosm.net/db/files/Comics/[A-Za-z0-9/]*.png' $dir/pageSource);
        imageName="Cyanide&Happiness_"`echo $imageLink | grep -o "[a-zA-Z0-9_]*.png"`;
elif [ $n -eq 2 ]
then
	# fetch PhD Comics strip
        wget -q -O $dir/pageSource 'http://www.phdcomics.com/comics/archive_list.php';
        max_num_comics=$(grep -o 'http://www.phdcomics.com/comics/archive.php?comicid=[0-9]*' $dir/pageSource | grep -o [0-9]* | tail -1);
        comicid=`echo "$RANDOM % $max_num_comics" | bc`;

        wget -q -O $dir/pageSource 'http://www.phdcomics.com/comics/archive.php?comicid='$comicid;
        imageLink=$(grep -o 'http://www.phdcomics.com/comics/archive/phd[0-9]*s.gif' $dir/pageSource | tail -1 );
        imageName='PhDComics_'`echo $imageLink | grep -o "[a-zA-Z0-9_]*.gif"`;

elif [ $n -eq 3 ]
then
        # fetch Garfield Comics strip
        wget -q -O $dir/pageSource 'http://garfield.com/comic/random';
        imageLink=$(grep -o '/uploads/strips/[0-9-]*.jpg' $dir/pageSource);
	imageLink='http://garfield.com'$imageLink; 
        imageName="Garfield_"`echo $imageLink | grep -o "[a-zA-Z0-9_]*.jpg"`;
elif [ $n -eq 4 ]
then
        # fetch Abstruse Goose Comics strip
        wget -q -O $dir/pageSource 'http://abstrusegoose.com/pseudorandom.php';
		page=$(grep -P -o 'http://abstrusegoose.com/[0-9]*' $dir/pageSource);
		wget -q -O $dir/pageSource "$page";
        imageLink=$(grep -o 'http://abstrusegoose.com/strips/[a-zA-Z0-9_]*.png' $dir/pageSource);
        imageName="AbruseGoose_"`echo $imageLink | grep -o "[a-zA-Z0-9_]*.png"`;
fi




if [ ! -f "$dir/$imageName" ]; then
	echo "Fetching Image";
	wget -q -O $dir/$imageName $imageLink;
fi
rm $dir/pageSource
eog $dir/$imageName & disown
