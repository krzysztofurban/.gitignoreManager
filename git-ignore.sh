#!/bin/bash

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
current_dir=$PWD
submodule_array=(
    "https://github.com/github/gitignore.git" 
)

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1
fi

if [[ $1 == "--install" || $1 == "-i" ]]
then
    installation_dir=$SOURCE_DIR
    gitignore_dir="$installation_dir/gitIgnore"

    if [ -d "$gitignore_dir" ] 
    then
        echo "Directory already exist"
    else
        echo "Directory doesn't exists"
        (cd $installation_dir && mkdir gitIgnore)
        (cd $gitignore_dir && mkdir myGitignore && touch ./myGitIgnore/myExample.gitignore)
    fi	

    if [ ! -d "$gitignore_dir" ] 
    then
        echo "Something goes wrong with initializing directory for installation"
    else
        (cd $gitignore_dir && git init)
        for entry in ${submodule_array[*]}
        do
            (cd $gitignore_dir && git submodule add -b master $entry)
        done
        (cd $gitignore_dir && git submodule init)
    fi
    exit 1
fi

if [[ $1 == "--update" || $1 == "-u" ]]
then
    if [ ${#2} -eq 0 ]
    then
        installation_dir=$PWD
    else
        installation_dir=$2
    fi
    installation_dir="$installation_dir/gitIgnore"
    (cd $installation_dir && git submodule update --remote --merge)
    exit 1
fi

dirlist=(`find $SOURCE_DIR -print -type f | grep -i "${1}"`)

if [ ${#dirlist[@]} == 0 ]; 
then
    echo "There is no specified gitignore file in your example directory"
    exit 1
fi

if [ ${#dirlist[@]} == 1 ]; 
then
    file=${dirlist[0]}
    echo "Do you wanna copy $file to your directory? [y/n]"
    read answer
    if [[ $answer == "yes" || $answer == "y" ]]
    then 
        cp $dirlist "$current_dir/.gitignore"
        echo "Copied $dirlist into $PWD"
    else
        echo "Copy action cancelled!"
        exit 1
    fi
else
    echo "Your search was ambigous, I've found specified files:"
    for entry in ${dirlist[*]}
    do
        fileName=$(basename $entry)
        echo $fileName
    done
fi