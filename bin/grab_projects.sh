#!/bin/bash

# REQUIRED: git

#Move into required directory
printf "\tMaking project storage directory: %s \n" $1
# Remove if exists
rm -r -f $1
# Make new directory
mkdir $1
# Move into new directory
cd $1

# Declare an array of projects
declare -a projects=("DirectEffBCGPolicyChange" "ETSMissing" 
                     "AssessBCGPolicyChange" "ModelTBBCGEngland"
                     "tbinenglanddataclean" "ExploreBCGOnOutcomes") 


# Iterate the projects array using for loop
# git clone each project
for project in ${projects[@]}; 
do
   printf "\tCloning project: %s into projects: %s\n" $project $1
   git clone "https://github.com/seabbs/$project.git"
done


# Move out of specified directory
cd ..