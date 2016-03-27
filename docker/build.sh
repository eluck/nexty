#!/usr/bin/env bash


#check whether we're in a nexty directory
gitRoot=`git rev-parse --show-toplevel 2>/dev/null`
if [ -z $gitRoot"" ] ; then
  echo -e "\nYou are not in nexty directory."
  echo    "Please run this script from nexty git repository"
  echo -e "Aborting...\n"
  exit
fi


#cd into the repo root
if [ ! `pwd` == $gitRoot ] ; then
  echo -e "\nChanging to nexty directory: $gitRoot"
  cd $gitRoot
fi


#check whether the repo is clean
if [ "`git status -s`" ] ; then
  echo -e "\nThe repository is not clean."
  echo "Please commit all your changes and run this script again."
  echo -e "Aborting...\n"
  exit
fi


#ensure we got docker vm running and accessible
docker-machine start dev ; eval `docker-machine env dev`


docker build -f webapp/Dockerfile -t eluck/nexty ./webapp
