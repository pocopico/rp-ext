for ext in `ls `
do

cat $ext/rpext-index.json |jq .releases[] | awk -F \/ '{print "cat " $7 "/" $8 "/" $9}' |sed -e 's/"//' | sh - |jq .files[].url|awk -F \/ '{print "sha256sum " $7 "/" $8 "/" $9}'|sed -e 's/"//' |sh -

done
