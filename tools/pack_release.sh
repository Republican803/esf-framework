#!/bin/bash

# pack_release.sh: Zips [esf] resources for release.

RELEASE_DIR="release"
ZIP_NAME="esf-framework-resources.zip"

mkdir -p $RELEASE_DIR
zip -r $RELEASE_DIR/$ZIP_NAME resources/[esf]
echo "Zipped to $RELEASE_DIR/$ZIP_NAME"