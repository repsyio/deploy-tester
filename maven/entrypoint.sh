#!/usr/bin/env bash

if [ -z "$REPSY_BASE_URL" ]; then
  export REPSY_BASE_URL="https://repo.repsy.io"
fi

mkdir -p "$HOME/.m2"

  cat <<EOF >~/.m2/settings.xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
    http://maven.apache.org/xsd/settings-1.0.0.xsd">

    <servers>
        <server>
            <id>repsy</id>
            <username>${REPSY_USERNAME}</username>
            <password>${REPSY_REPO_PASSWORD}</password>
        </server>
    </servers>
</settings>
EOF

# maven-hello-world-jar ========================================================

cd /opt/deploy/maven-hello-world-jar || exit 1
mvn -ntp deploy

# clean cache for making sure the result is not coming from maven cache
rm -rf "$HOME/.m2/repository/io/repsy/helloworld"

cd /opt/use/maven-hello-world-jar || exit 1
mvn -ntp package dependency:copy-dependencies
EXEC_VALUE=$(java -cp target/dependency/maven-hello-world-jar-1.0.0.jar:target/use-maven-hello-world-jar.jar io.repsy.hello_world.use.maven_hello_world_jar.Main)

if [ "Hello World!" != "$EXEC_VALUE" ]; then
  exit 1
fi
