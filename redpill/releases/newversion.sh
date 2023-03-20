
for file in `ls *42218*.json|grep -v 3615 |grep -v sa6400`
do
model=`echo $file | awk -F\_ '{print $1}'`
echo -n $model
cp ${model}_42218.json ${model}_64216.json
platform=` jq .files[].name ${model}_64216.json |head -1| awk -F\- '{print $3}'|sed -e  's/.tgz"//'`
filename=`ls *302* |grep -w ${platform}`
sed -i 's/redpill-4.4.180plus-${platform}.tgz/redpill-4.4.302plus-${platform}.tgz/g' ${model}_64216.json
hash=`jq -r -e .files[].sha256 ${model}_64216.json |head -1`
newhash=`sha256sum $filename|awk '{print $1}'`
sed -i "s/$hash/$newhash/g" ${model}_64216.json
echo "-> DONE"
done


