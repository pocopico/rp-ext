#!/bin/bash

PLATFORMS="apollolake broadwell broadwellnk bromolow denverton epyc7002 geminilake r1000 v1000 purley"
BUILDMODE="prod"

function shacalc() {
  sha256sum "$1" | awk '{print $1}'
}

function rpext() {

  platform="$1"
  kver="$2"
  revision="$3"

  cat <<EOF >tmp.rpext
{
  "id": "pocopico.redpilldev",
  "url": "https://raw.githubusercontent.com/pocopico/rp-ext/master/redpill${BUILDMODE}/rpext-index.json",
  "info": {
    "name": "redpill",
    "description": "Adds  Support",
    "author_url": "https://github.com/pocopico",
    "packer_url": "https://github.com/pocopico/rp-ext/tree/main/redpill",
    "help_url": "<todo>"
  },
  "releases": {
EOF

  for platform in $PLATFORMS; do
    for kver in $(kvers $platform); do
      platforms $platform
      for revision in $(revisions $kver); do
        for model in $(models $platform); do
          echo "\"${model}_${revision}\": \"https://raw.githubusercontent.com/pocopico/rp-ext/master/redpill${BUILDMODE}/releases/${platform}_${revision}.json\"," >>tmp.versions
        done
      done
    done
  done

  listmodels >>tmp.rpext

  cat <<EOF >>tmp.rpext
    "endofmodel": "endofurls"
  }
}
EOF

  jq . tmp.rpext >rpext-index.json && rm -f tmp.rpext && rm -f tmp.versions

}

function listmodels() {

  for platform in $PLATFORMS; do
    for model in $(models $platform); do
      grep $model tmp.versions
    done
  done

}

function content() {

  platform="$1"
  kver="$2"
  revision="$3"

  gunzip -f lastmods/rp-${platform}-${kver}-${BUILDMODE}.ko.gz 2>/dev/null
  cp -f lastmods/rp-${platform}-${kver}-${BUILDMODE}.ko redpill.ko
  tar cfz redpill-${platform}-${kver}.tgz redpill.ko
  rm -f ./redpill.ko
  echo "Creating content for platform: $platform revision: $revision kver: $kver"
  cat <<EOF >${platform}_${revision}.json
{
  "mod_version": "v1",

  "files": [
    {
      "name": "redpill-${kver}-${platform}.tgz",
      "url": "https://raw.githubusercontent.com/pocopico/rp-ext/master/redpill${BUILDMODE}/releases/redpill-${platform}-${kver}.tgz",
      "sha256": "$(shacalc redpill-${platform}-${kver}.tgz)",
      "packed": true
    },
    {
      "name": "check-redpill.sh",
      "url": "https://raw.githubusercontent.com/pocopico/rp-ext/master/redpill${BUILDMODE}/src/check-redpill.sh",
      "sha256": "$(shacalc ../src/check-redpill.sh)",
      "packed": false
    }
  ],

  "kmods": {
    "redpill.ko": ""
  },

    "scripts": {
    "on_boot": "check-redpill.sh"
  }

}
EOF
}

function platforms() {

  case $1 in

  ds1019p | ds918p | ds620slim) platform="apollolake" ;;
  ds1520p | ds920p | dva1622 | ds720p) platform="geminilake" ;;
  ds1621p | ds1821p | rs1221p |ds2422p | fs2500) platform="v1000" ;;
  ds1621xsp | ds3622xsp | rs3621xsp | rs4021xsp) platform="broadwellnk" ;;
  ds3615xs | rs3413xsp) platform="bromolow" ;;
  ds3617xs | rs3618xs) platform="broadwell" ;;
  ds723p | ds923p) platform="r1000" ;;
  dva3219 | dva3221 |ds1819p ) platform="denverton" ;;
  fs6400) platform="purley" ;;
  sa6400) platform="epyc7002" ;;
  esac
}

function models() {

  case $1 in

  apollolake) echo "ds1019p ds918p ds620slim" ;;
  geminilake) echo "ds1520p ds720p ds920p  dva1622" ;;
  v1000) echo "ds1621p  ds2422p ds1821+ rs1221p fs2500" ;;
  broadwellnk) echo "ds1621xs  ds3622xsp rs3621xsp rs4021xsp" ;;
  bromolow) echo "ds3615xs rs3413xsp" ;;
  broadwell) echo "ds3617xs  rs3618xs" ;;
  r1000) echo "ds723p  ds923p" ;;
  denverton) echo "dva3219  dva3221 ds1819p ds1823xsp" ;;
  purley) echo "fs6400" ;;
  epyc7002) echo "sa6400" ;;
  esac
}

function revisions() {

  case $1 in
  5.10.55) echo "42218 42661 42962 64551 64570 69057" ;;
  4.4.59) echo "25556" ;;
  4.4.180) echo "42218 42661 42962" ;;
  4.4.302) echo "64561 64570 69057" ;;
  3.10.105) echo "25556" ;;
  3.10.108) echo "42218 42661 42962" ;;
  esac

}

function kvers() {

  case $1 in

  apollolake) echo "4.4.59 4.4.180 4.4.302" ;;
  denverton) echo "4.4.59 4.4.180 4.4.302" ;;
  broadwell) echo "3.10.105 4.4.180 4.4.302" ;;
  broadwellnk) echo "4.4.59 4.4.180 4.4.302" ;;
  r1000) echo "4.4.180 4.4.302" ;;
  v1000) echo "4.4.59 4.4.180 4.4.302" ;;
  geminilake) echo "4.4.59 4.4.180 4.4.302" ;;
  bromolow) echo "3.10.105 3.10.108" ;;
  epyc7002) echo "5.10.55" ;;
  purley) echo "4.4.59 4.4.180 4.4.302" ;;

  esac

}

buildconfig() {

  platform="$1"
  kver="$2"
  revision="$3"

  case $1 in

  esac

}

rm -rf releases && mkdir -p releases && cd releases

echo "Downloading latest rp-lkms release from GitHub"

URL=$(curl --connect-timeout 15 -s --insecure -L https://api.github.com/repos/wjz304/redpill-lkm/releases/latest | jq -r -e .assets[].browser_download_url | grep rp-lkms.zip)

curl --insecure --progress-bar -sL $URL -o rp-lkms.zip
mkdir -p lastmods && 7z x rp-lkms.zip *${BUILDMODE}* -olastmods >/dev/null 2>&1

echo $PLATFORMS

for platform in $PLATFORMS; do

  for kver in $(kvers $platform); do
    platforms $platform
    for revision in $(revisions $kver); do
      content $platform $kver $revision
    done
  done
done

sync && rm -rf lastmods rp-lkms.zip

cd ../
rpext
