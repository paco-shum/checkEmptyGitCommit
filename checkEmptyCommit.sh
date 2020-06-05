#!/bin/bash
dir=$(pwd)
gitrepo=$1

#Check repo name
if [ "$gitrepo" == "" ]
then
	echo "No repository name supplied"
	exit 1
fi

cd $gitrepo

echo "--$gitrepo" >> $dir/checkEmptyCommit.txt
git checkout -f master

git for-each-ref --format='%(refname)' refs/remotes/ | while read branch_ref; do 
	branch=${branch_ref#refs/remotes/}
	echo $branch
	git checkout -f $branch
	echo "--$gitrepo/$branch" >> $dir/checkEmptyCommit.txt
	git log --pretty="#@#@#@#@#@#@%H---%ci---%s" --shortstat | tr "\n" " " | sed "s/#@#@#@#@#@#@/\n/g" | grep -v -E ".*((file)|(files) changed)|(Merge pull request)|(Merge branch).*" >> $dir/checkEmptyCommit.txt
	printf "\n" >> $dir/checkEmptyCommit.txt
done

git checkout -f master
cd $dir