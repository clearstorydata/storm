#!/bin/bash

set -e -u -o pipefail

RELEASE=`head -1 project.clj | awk '{print $3}' | sed -e 's/\"//' | sed -e 's/\"//'`

rm -rf classes
rm -f *jar
rm -f *xml
lein jar
lein pom
#scp storm*jar pom.xml clojars@clojars.org:

rm -f *jar
rm -rf classes
rm -f conf/log4j.properties
lein jar
mv pom.xml old-pom.xml
sed 's/artifactId\>storm/artifactId\>storm-lib/g' old-pom.xml > pom.xml
mv storm-$RELEASE.jar storm-lib-$RELEASE.jar
#scp storm*jar pom.xml clojars@clojars.org:
rm -f *xml
rm -f *jar
git checkout conf/log4j.properties

