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

#echo "Application is $appid.But I don't knwo the name.$api_call_name"

echo "#!/bin/sh -l" > getbuildid.sh
echo ""
echo "java -jar VeracodeJavaAPI.jar \\
        -vid \"$vid\" \\
        -vkey \"$vkey\" \\
        -action \"$api_call_name\" \\
        -appid \"$appid\" \\ " >> getbuildid.sh

javawrapperversion=$(curl https://repo1.maven.org/maven2/com/veracode/vosp/api/wrappers/vosp-api-wrappers-java/maven-metadata.xml | grep latest |  cut -d '>' -f 2 | cut -d '<' -f 1)

echo "javawrapperversion: $javawrapperversion"

curl -sS -o VeracodeJavaAPI.jar "https://repo1.maven.org/maven2/com/veracode/vosp/api/wrappers/vosp-api-wrappers-java/$javawrapperversion/vosp-api-wrappers-java-$javawrapperversion.jar"
chmod 777 getbuildid.sh
cat getbuildid.sh
./getbuildid.sh > output.xml
 # build info is saved in output.xml

sed -i s+"xmlns=".*\"" "+" "+g output.xml

# sed -i s+"xmlns=(\".*?\")"+" "+g output.xml
cat output.xml
build_id=$(xmllint --xpath 'string(//buildinfo/@build_id)' output.xml)
echo "Build_id: $build_id"

status=$(xmllint --xpath 'string(//analysis_unit/@status)' output.xml)
echo "Status: $status"


filepath="summaryreport.xml"
echo "#!/bin/sh -l" > getscore.sh
echo ""
echo "java -jar VeracodeJavaAPI.jar -vid $vid -vkey $vkey -action \"summaryreport\" -buildid $build_id -outputfilepath $filepath" >> getscore.sh
ls -lrt

chmod 777 getscore.sh
cat getscore.sh
./getscore.sh 
ls -lrt
# cat summaryreport.xml

# sed -i s+"xmlns=\"https://www.veracode.com/schema/reports/export/1.0\""+" "+g summaryreport.xml
sed -i s+"xmlns=".*\"" "+" "+g summaryreport.xml
score=$(xmllint --xpath 'string(//summaryreport/static-analysis/@score)' summaryreport.xml)
echo "Score = $score"

# echo "before"
# cat output2.xml
# sed -i s+"</buildinfo>"+" "+g output2.xml
# echo "after removing"
# cat output2.xml
# build_id=$(xmllint --xpath 'string(//build/@build_id)' output2.xml)



# build_id=$(awk -F 'build_id=' '{print $2}' output.xml | head -c 11) success

# status=$(awk -F 'analysis_type=' '{print $2}' output.xml | tail -c 30)



# file=output.xml


# file="output.xml" 
  
# i=1  
# while read line; do    
# #Reading each line  
# echo "Line No. $i : $line"  
# i=$((i+1))  
# done < $file  
