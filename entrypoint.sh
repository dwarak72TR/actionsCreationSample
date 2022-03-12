#!/bin/sh -l

#required parameters
vid=$1
vkey=$2
api_call_name=$3
appid=$4

echo "Required Information"
echo "===================="
echo "appid: $appid"
echo "api_call_name: $api_call_name"
echo "vid: $vid"
echo "vkey: $vkey"

if [ "$vid" ]
then
echo "vid: ***"
else
echo "vid:"
fi

if [ "$vkey" ]
then
echo "vkey: ***"
else
echo "vkey:"
fi

if [ -z "$appid" ] || [ -z "$vid" ] || [ -z "$vkey" ] || [-z "$api_call_name"]
then
        echo "Missing required parameter. Please check that all required parameters are set"
        exit 1
fi

echo "Application is $appid.But I don't knwo the name"
# echo "#!/bin/sh -l" > runJava.sh
# echo ""
# echo "java -jar vosp-api-wrappers-java-<version #>.jar \\
#         -vid \"$vid\" \\
#         -vkey \"$vkey\" \\
#         -action \"$api_call_name\" \\
#         -appname \"$appid\" \\ " >> runJava.sh


# javawrapperversion=$(curl https://repo1.maven.org/maven2/com/veracode/vosp/api/wrappers/vosp-api-wrappers-java/maven-metadata.xml | grep latest |  cut -d '>' -f 2 | cut -d '<' -f 1)

# #echo "javawrapperversion: $javawrapperversion"

# curl -sS -o VeracodeJavaAPI.jar "https://repo1.maven.org/maven2/com/veracode/vosp/api/wrappers/vosp-api-wrappers-java/$javawrapperversion/vosp-api-wrappers-java-$javawrapperversion.jar"
# chmod 777 runJava.sh
# cat runJava.sh
# ./runJava.sh