#! /bin/bash

#
# Copyright (C) 2020 StarLight5234
# Copyright (C) 2021-2023 Unitrix Kernel
#

DEVICE="xiaomi vince"
TC_PATH="/workspace/dib12/clang"
COMPILER_NAME="clang"
LD_NAME="ld.lld"
CROSS_COMPILE_ARM64="aarch64-linux-gnu-"
CROSS_COMPILE_ARM32="arm-linux-gnueabi-"
EXTRA_CMDS="LLVM=1 LLVM_IAS=1"
DEFCONFIG="vince-perf_defconfig"
OUT_DIR="$(pwd)/out"
KERNEL_IMG="$OUT_DIR/arch/arm64/boot/Image.gz-dtb"
KBUILD_BUILD_USER="dib12"
KBUILD_BUILD_HOST="codespace"
TZ="Asia/Kolkata"
ZIP_DIR="/workspace/dib12/AnyKernel3"



# clone toolchain
function clone_tc() {
    if ! [ -d "$TC_PATH" ]; then
        git clone -b lineage-20.0 https://github.com/LineageOS/android_prebuilts_clang_kernel_linux-x86_clang-r416183b $TC_PATH
    fi
}

# clone anykernel3
function clone_anykernel3() {
    if ! [ -d $ZIP_DIR ]; then
        git clone -b master https://github.com/dib12/AnyKernel3 $ZIP_DIR
    fi
}

# Make Kernel
function build_kernel() {
    DATE=$date
    BUILD_START=$(date +"%s")
    make ARCH=arm64 CC=$COMPILER_NAME LD=$LD_NAME CROSS_COMPILE=$CROSS_COMPILE_ARM64 CROSS_COMPILE_ARM32=$CROSS_COMPILE_ARM32 $EXTRA_CMDS O=$OUT_DIR $DEFCONFIG
    make ARCH=arm64 CC=$COMPILER_NAME LD=$LD_NAME CROSS_COMPILE=$CROSS_COMPILE_ARM64 CROSS_COMPILE_ARM32=$CROSS_COMPILE_ARM32 $EXTRA_CMDS O=$OUT_DIR -j$(nproc --all) |& tee -a $HOME/build/build$BUILD.txt
    BUILD_END=$(date +"%s")
    DIFF=$(($BUILD_END - $BUILD_START))
}

# Make flashable zip
function make_flashable() {
    make -C $ZIP_DIR clean &>/dev/null
    cp $KERNEL_IMG $ZIP_DIR
    cp -rf $(find $OUT_DIR -name "*.ko") $ZIP_DIR/modules/system/lib/modules &>/dev/null
    if [[ $(find $ZIP_DIR/modules/system/lib/modules -name *.ko) ]]; then
	sed -i "s/do.modules=0/do.modules=1/g" $ZIP_DIR/anykernel.sh
    else
	sed -i "s/do.modules=1/do.modules=0/g" $ZIP_DIR/anykernel.sh
    fi
    make LINUX_VERSION="$KERNEL_VERSION" -C $ZIP_DIR stable &>/dev/null
}

# Credits: @madeofgreat
BTXT="$HOME/build/buildno.txt" #BTXT is Build number TeXT
if ! [ -a "$BTXT" ]; then
    mkdir $HOME/build
    touch $HOME/build/buildno.txt
    echo $RANDOM > $BTXT
fi
BUILD=$(cat $BTXT)
BUILD=$(($BUILD + 1))
echo $BUILD > $BTXT

# The magic begins here.
clone_tc
PATH="$TC_PATH/bin:$PATH"
make mrproper &>/dev/null
if ! [ -d "$OUT_DIR" ]; then
rm -rf $OUT_DIR
fi
build_kernel
clone_anykernel3
make_flashable
