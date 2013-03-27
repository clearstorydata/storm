#!/bin/bash

time (

set -e -u -o pipefail -x
cd $(dirname $0)/..
mkdir -p target

version=`head -1 project.clj | awk '{print $3}' | sed -e 's/\"//' | sed -e 's/\"//'`

# Build storm
rm -rf classes
rm -f *jar
rm -f *xml
rm -f pom.xml

lein jar
lein pom

mv -f storm-$version.jar target
cp -f pom.xml target/storm-$version.pom

# Build storm-lib
rm -f *jar
rm -rf classes
rm -f conf/log4j.properties

lein jar
mv pom.xml old-pom.xml
sed 's/artifactId\>storm/artifactId\>storm-lib/g' old-pom.xml > pom.xml

mv -f storm-$version.jar target/storm-lib-$version.jar
mv -f pom.xml target/storm-lib-$version.pom

rm -f *xml
rm -f *jar
git checkout conf/log4j.properties

)

