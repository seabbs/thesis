#!/bin/bash

# REQUIRED: git

#Move into required directory
printf "\tMaking (moving to) project storage directory: %s \n" $1
# Make new directory
mkdir $1
# Move into new directory
cd $1

# Declare an array of projects
declare -a projects=("DirectEffBCGPolicyChange" "ETSMissing"
                     "AssessBCGPolicyChange" "ModelTBBCGEngland"
                     "tbinenglanddataclean" "ExploreBCGOnOutcomes"
                     "getTBinR")


# Iterate the projects array using for loop
# git clone each project
for project in ${projects[@]}; do
  if ([ -e $project ]); then
    printf "\tUpdating project: %s \n" $project
    cd $project
    git pull
    cd ..
  else
    printf "\tCloning project: %s into projects: %s\n" $project $1
    git clone "https://github.com/seabbs/$project.git"
  fi
done
