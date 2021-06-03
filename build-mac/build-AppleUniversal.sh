#!/bin/zsh
set -e

WORKING_DIR=$(pwd)

FRAMEWORK_FOLDER_NAME="LibetPan_XCFramework"

FRAMEWORK_NAME="LibetPan"

WORKSPACE="libetpan.xcworkspace"

FRAMEWORK_PATH="${WORKING_DIR}/${FRAMEWORK_FOLDER_NAME}/${FRAMEWORK_NAME}.xcframework"

BUILD_SCHEME="libetpan"

SIMULATOR_ARCHIVE_PATH="${WORKING_DIR}/${FRAMEWORK_FOLDER_NAME}/simulator.xcarchive"

IOS_DEVICE_ARCHIVE_PATH="${WORKING_DIR}/${FRAMEWORK_FOLDER_NAME}/iOS.xcarchive"

CATALYST_ARCHIVE_PATH="${WORKING_DIR}/${FRAMEWORK_FOLDER_NAME}/catalyst.xcarchive"

rm -rf "${WORKING_DIR}/${FRAMEWORK_FOLDER_NAME}"
echo "Deleted ${FRAMEWORK_FOLDER_NAME}"
mkdir "${FRAMEWORK_FOLDER_NAME}"
echo "Created ${FRAMEWORK_FOLDER_NAME}"
echo "Archiving ${FRAMEWORK_NAME}"

echo "Removing ${SIMULATOR_ARCHIVE_PATH}"
rm -rf "${SIMULATOR_ARCHIVE_PATH}"
echo "Removing ${IOS_DEVICE_ARCHIVE_PATH}"
rm -rf "${IOS_DEVICE_ARCHIVE_PATH}"
echo "Removing ${CATALYST_ARCHIVE_PATH}"
rm -rf "${CATALYST_ARCHIVE_PATH}"

echo ---------------------------------------------------------LibetPan_Simulator---------------------------------------------------------
xcodebuild archive ONLY_ACTIVE_ARCH=NO -workspace ${WORKSPACE} -scheme "libetpan ios" -destination="generic/platform=iOS Simulator" -archivePath "${SIMULATOR_ARCHIVE_PATH}" -sdk iphonesimulator SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES -quiet

echo ---------------------------------------------------------LibetPan_iOS---------------------------------------------------------
xcodebuild archive -workspace ${WORKSPACE} -scheme "libetpan ios" -destination="generic/platform=iOS" -archivePath "${IOS_DEVICE_ARCHIVE_PATH}" -sdk iphoneos SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES -quiet

echo ---------------------------------------------------------LibetPan_macOS---------------------------------------------------------
xcodebuild archive -workspace ${WORKSPACE} -scheme ${BUILD_SCHEME} -destination='generic/platform=macOS,variant=Mac Catalyst' -archivePath "${CATALYST_ARCHIVE_PATH}" SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES -quiet

echo ---------------------------------------------------------LibetPan_XCFramework---------------------------------------------------------
xcodebuild -create-xcframework -framework ${SIMULATOR_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework -framework ${IOS_DEVICE_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework -framework ${CATALYST_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework -output "${FRAMEWORK_PATH}" -quiet

rm -rf "${SIMULATOR_ARCHIVE_PATH}"
rm -rf "${IOS_DEVICE_ARCHIVE_PATH}"
rm -rf "${CATALYST_ARCHIVE_PATH}"
open "${WORKING_DIR}/${FRAMEWORK_FOLDER_NAME}"
