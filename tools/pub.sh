#!/bin/bash

echo '### flutter_dropzone'

cd ./flutter_dropzone
flutter pub upgrade
cd $OLDPWD

echo '### flutter_dropzone_platform_interface'

cd ./flutter_dropzone_platform_interface
flutter pub upgrade
cd $OLDPWD

echo '### flutter_dropzone_web'

cd ./flutter_dropzone_web
flutter pub upgrade
cd $OLDPWD

echo '### all done'
