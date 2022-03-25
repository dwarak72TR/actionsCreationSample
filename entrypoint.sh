#!/bin/sh -l

#required parameters
appid=$1
api_call_name=$2
vid=$3
vkey=$4


echo "Required Information"
echo "===================="
echo "appid: $appid"
echo "api_call_name: $api_call_name"
echo "vid: $vid"
echo "vkey: $vkey"

if [ "$vid" ]
then
echo "vid: *************"
else
echo "vid:"
fi

if [ "$vkey" ]
then
echo "vkey: ***********"
else
echo "vkey:"
fi

# if $api_call_name == "summaryreport"
# then
if [ -z "$appid" ] || [ -z "$vid" ] || [ -z "$vkey" ] || [ -z "$api_call_name"]
then
        echo "Missing required parameter. Please check that all required parameters are set"
        exit 1
fi

javawrapperversion=$(curl https://repo1.maven.org/maven2/com/veracode/vosp/api/wrappers/vosp-api-wrappers-java/maven-metadata.xml | grep latest |  cut -d '>' -f 2 | cut -d '<' -f 1)

echo "javawrapperversion: $javawrapperversion"
curl -sS -o VeracodeJavaAPI.jar "https://repo1.maven.org/maven2/com/veracode/vosp/api/wrappers/vosp-api-wrappers-java/$javawrapperversion/vosp-api-wrappers-java-$javawrapperversion.jar"

get_build () {

echo "#!/bin/sh -l" > getbuildid.sh
echo ""
echo "java -jar VeracodeJavaAPI.jar \\
        -vid \"$vid\" \\
        -vkey \"$vkey\" \\
        -action \"$api_call_name\" \\
        -appid \"$appid\" \\ " >> getbuildid.sh

chmod 777 getbuildid.sh
cat getbuildid.sh
./getbuildid.sh > output.xml
 # latest apllication buildinfo is saved in output.xml

#getting Build ID from XML file
sed -i s+"xmlns=\".*\""+" "+g output.xml
# cat output.xml
build_id=$(xmllint --xpath 'string(//buildinfo/build/@build_id)' output.xml)
echo "Build_id: $build_id"

#getting status from XML file
status=$(xmllint --xpath 'string(//analysis_unit/@status)' output.xml)
echo "Status: $status"

#getting version from XML file
version=$(xmllint --xpath 'string(//buildinfo/build/@version)' output.xml)
echo "Version: $version"
}

get_score () { 
#getting score 
filepath="summaryreport.xml"
echo "#!/bin/sh -l" > getscore.sh
echo ""
echo "java -jar VeracodeJavaAPI.jar -vid $vid -vkey $vkey -action \"summaryreport\" -buildid $build_id -outputfilepath $filepath" >> getscore.sh

chmod 777 getscore.sh
cat getscore.sh
#run getscore.sh file
./getscore.sh 

#Retrieve Score from Summary report
sed -i s+"xmlns=\".*\""+" "+g summaryreport.xml
score=$(xmllint --xpath 'string(//summaryreport/static-analysis/@score)' summaryreport.xml)
echo "Score = $score"
}       


get_build