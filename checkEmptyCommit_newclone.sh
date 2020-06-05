#!/bin/bash
dir=$(pwd)
gitrepoURL=$2
gitrepoName=$1

#Check repo name
if [ "$gitrepoURL" == "" ]
then
	echo "No repository url supplied"
	exit 1
fi
if [ "$gitrepoName" == "" ]
then
	echo "No repository url supplied"
	exit 1
fi

mkdir .checkEmptyCommit
cd .checkEmptyCommit
git clone $gitrepoURL

cd $gitrepoName

echo "--$gitrepoName" >> $dir/checkEmptyCommit.txt
git checkout -f master

git for-each-ref --format='%(refname)' refs/remotes/ | while read branch_ref; do 
	branch=${branch_ref#refs/remotes/}
	echo $branch
	git checkout -f $branch
	echo "--$gitrepoName/$branch" >> $dir/checkEmptyCommit.txt
	git log --pretty="#@#@#@#@#@#@%H---%ci---%s" --shortstat | tr "\n" " " | sed "s/#@#@#@#@#@#@/\n/g" | grep -v -E ".*((file)|(files) changed)|(Merge pull request)|(Merge branch).*" >> $dir/checkEmptyCommit.txt
	printf "\n" >> $dir/checkEmptyCommit.txt
done

cd $dir
rm -fr .checkEmptyCommit