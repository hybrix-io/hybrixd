#!/bin/sh
OLDPATH=$PATH
WHEREAMI=$(pwd)

export PATH=$WHEREAMI/node_binaries/bin:"$PATH"

echo "[i] Install zip"
apt-get -qq update
apt-get -qq install -y zip

echo "[i] Install sshpass"
apt-get -qq install -y sshpass;

VERSION="v"$(cat package.json | grep version | cut -d'"' -f4)
echo "[i] Version $VERSION"

mkdir -p /dist

FILE_NAME="hybrixd.$VERSION"
LATEST_FILE_NAME="hybrixd.latest"
mkdir -p /hybrixd


echo "[.] Clean distributables"
sh ./scripts/pipeline/clean.sh

echo "[.] Create packed distributables"

zip -rq "/dist/${FILE_NAME}.zip" .
tar -zcf "/dist/${FILE_NAME}.tar.gz" .

echo "[.] Copying to latest folder"
rsync -ra --rsh="$RELEASE_OPTIONS" "/dist/${FILE_NAME}.zip" "$RELEASE_TARGET/hybrixd/latest/$LATEST_FILE_NAME.zip"
rsync -ra --rsh="$RELEASE_OPTIONS" "/dist/${FILE_NAME}.tar.gz" "$RELEASE_TARGET/hybrixd/latest/$LATEST_FILE_NAME.tar.gz"

echo "[.] Copying to version folder"
rsync -ra --rsync-path="mkdir -p $RELEASE_DIR/hybrixd/$VERSION/ && rsync" --rsh="$RELEASE_OPTIONS" "/dist/${FILE_NAME}.zip" "$RELEASE_TARGET/hybrixd/$VERSION/$FILE_NAME.zip"
rsync -ra --rsh="$RELEASE_OPTIONS" "/dist/${FILE_NAME}.tar.gz" "$RELEASE_TARGET/hybrixd/$VERSION/$FILE_NAME.tar.gz"

export PATH="$OLDPATH"
cd "$WHEREAMI"

exit 0
