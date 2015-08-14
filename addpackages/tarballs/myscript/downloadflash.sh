#!/bin/bash

cd `dirname $0`
. ./script_root.sh
source addhistory.sh

# downloadflash�ϥҥ��ȥ�˵�Ͽ���ʤ���ɬ����ư�ǵ�ư���ƥ��󥹥ȡ��뤹���
#addhistory $0

if [ -e /opt/google/chrome/PepperFlash/manifest.json ]; then

  old_version=`grep version /opt/google/chrome/PepperFlash/manifest.json | grep -o -E '[0-9\.]*'`
  echo The current version of Flash Player is : ${old_version}
  echo Start the update...
else
  echo "Flash Player isn't installed."
  echo Start a new installation...
fi

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib
export PATH=${PATH}:/usr/local/bin
# download chrome stable version(x86)
echo Download the Chrome package...
echo 
cd /tmp
mkdir chrome_work
cd chrome_work

if [ -e google-chrome-stable_current_i386.deb ]; then
  rm google-chrome-stable_current_i386.deb
fi
wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
if [ 0 -ne $? ]; then
  echo Download failed. Abort..
  exit 1
fi
echo
echo Download is completed.
echo

echo Extract the package...
ar x google-chrome-stable_current_i386.deb
#tar xf data.tar.lzma --lzma
xz -dv data.tar.xz
tar xf data.tar
echo 
echo Extracted.
echo

echo Create symlink. 

# remount / writable
mount -o remount,rw /
if [ 0 -ne $? ]; then
  echo Failed to remount root partition. Abort..
  exit 1
fi

ln -s ${script_root}/installflash.sh ${script_root}/pre-shutdown.sh
if [ 0 -ne $? ]; then
  echo Failed to create symlink. Abort..
  exit 1
fi

mount -r -o remount /

echo 
echo Ready to Install. Please reboot to start the installation.
