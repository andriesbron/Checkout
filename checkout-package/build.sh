#!/bin/bash
#chmod +x the_file_name
. ./env.sh  # or use `source ./env.sh` if using Bash

JOOMLA_ROOT=$SRC_BASE_DEVELOPMENT
BUILD_DIR="build"
COM_BUILD_DIR="build/com_"$COMPONENT_NAME
MANIFEST=$SRC_BASE_DEVELOPMENT"administrator/components/com_$COMPONENT_NAME/$COMPONENT_NAME.xml"
SCRIPT=$SRC_BASE_DEVELOPMENT"administrator/components/com_$COMPONENT_NAME/script.php"

ZIP_NAME="dist/com_$COMPONENT_NAME.$VERSION.zip"
echo $ZIP_NAME
if [ -e $ZIP_NAME ]; then
    echo "Version $VERSION already exists"
    exit
fi

# Clean build folder
echo "Cleaning old build..."
rm -rf "$BUILD_DIR"

#! Component Build
echo "Building component..."
mkdir -p "$COM_BUILD_DIR/admin"
mkdir -p "$COM_BUILD_DIR/site"
mkdir -p "$COM_BUILD_DIR/media"

# Copy files
echo "Copying admin files..."
cp -R "$SRC_ADMIN/"* "$COM_BUILD_DIR/admin/"
echo "Copying site files..."
cp -R "$SRC_SITE/"* "$COM_BUILD_DIR/site/"

if [ -d "$SRC_MEDIA" ]; then
    echo "Copying media files..."
    cp -R "$SRC_MEDIA/"* "$COM_BUILD_DIR/media/"
fi

echo "Copying manifest XML..."
rm "$COM_BUILD_DIR/admin/$COMPONENT_NAME.xml"
cp "$MANIFEST" "$COM_BUILD_DIR/"
cp "$SCRIPT" "$COM_BUILD_DIR/"

#! Module Build
echo "Building modules..."
mkdir -p "$BUILD_DIR/modules"
cp -r "$JOOMLA_ROOT/modules/mod_checkout" "$BUILD_DIR/modules/"

# Plugins
echo "Building plugins..."
mkdir -p "$BUILD_DIR/plugins/payment"
cp -r "$JOOMLA_ROOT/plugins/payment/" "$BUILD_DIR/plugins/payment/"

# Finally, create zip
echo "Creating zip package..."
cd build
#zip -r "../$ZIP_NAME" "com_$COMPONENT_NAME/"
zip -r "../$ZIP_NAME" *
cd ..

echo "Build complete: $ZIP_NAME"
