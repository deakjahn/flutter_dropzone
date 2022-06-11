#!/bin/bash

echo '### flutter_dropzone'

cd ./flutter_dropzone
flutter pub outdated
cd $OLDPWD

echo '### flutter_dropzone_platform_interface'

cd ./flutter_dropzone_platform_interface
flutter pub outdated
cd $OLDPWD

echo '### flutter_dropzone_web'

cd ./flutter_dropzone_web
flutter pub outdated
cd $OLDPWD

echo '### all done'
