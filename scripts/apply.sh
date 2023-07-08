cd plutosdr-fw
git apply ../patches/fw.diff --verbose
cd hdl
git apply ../../patches/hdl.diff --verbose
cd ../linux
git apply ../../patches/linux.diff --verbose
cd ../u-boot-xlnx
git apply ../../patches/u-boot-xlnx.diff --verbose
cd ../..
