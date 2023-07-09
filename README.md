# Pluto+DVB
This is a fork of the firmware of Pluto+ combined with datvplutofrm from F5OEO/F5UII

Original repositories are:
https://github.com/plutoplus/plutoplus
https://github.com/F5OEO/datvplutofrm

This is a software-defined radio platform that supports DVB transmission, it also supports Gigabit Ethernet and Micro SD card. 

The design inherited from the well-known ADI ADALM-PLUTO with several improvements.

[TOC]

## Specification

| Feature     | Details                                                      |
| ----------- | ------------------------------------------------------------ |
| SOC         | Zynq7zc010 with 28k LUTs                                     |
| ADC/DAC     | AD9363(Can hack to AD9361 or AD9364)  with 2 Transmit, 2 Receive channel |
| RF Range    | 70MHZ~6GHZ                                                   |
| Ref Clock   | VCTCXO 40MHZ 0.5ppm, with external clock input               |
| RAM         | 512MB                                                        |
| FLASH       | 32MB, SD Card                                                |
| Connections | USB：2.0  support OTG                                        |
|             | Ethernet：1Gb                                                |
| DC IN       | 5V +-0.5V-2A microUSB                                        |

![Front](./images/clip_image002.jpg)

![Back](./images/clip_image003.jpg)

### Schematics

Pluto+ has full schematics open sourced. You can find this in sch folder.

[Download Schematics](./sch/PLUTOX_SDR-V1.0-20201212.pdf)

[Download Top View](./sch/Top.pdf)

[Download Bottom View](./sch/Bottom.pdf)

## How to upgrade the firmware

## UDisk Upgrade
** PLEASE NOTE **
This software is experimental and I accept no liability for any damage that may occur to your Plutoplus by using it

The firmware/ folder contains pre-compiled binaries based on pluto firmware v0.33 and the latest datvplutofrm f5uii-master branch which I have successfully loaded on my Pluto+ (with minimal testing). It was built using Ubuntu 22.04.

Simply download the pluto.frm file and copy to the PlutoSDR drive on your computer, then eject the drive (the usual Pluto firmware upgrade method). LED1 (green) will flash rapidly for around 10 minutes and then the Plutoplus will reboot into the new firmware.

### DFU Upgrade
If you device is not responding anymore, you have to apply DFU procedure to unbrick it.
1. Download the firmware and unzip it.

2. Install dfu utility

5. Make Device enter DFU mode. There is a howto section below on the details steps.
   
4. Run DFU utility with the following command:

   ```
   sudo dfu-util -a boot.dfu -D ./boot.dfu
   sudo dfu-util -a firmware.dfu -D ./pluto.dfu
   ```

## How to build firmware manually


1. Install pre-requisite components
   ```
   sudo apt-get install git build-essential ccache device-tree-compiler dfu-util fakeroot help2man libncurses5 libncurses5-dev libtinfo5 libtinfo-dev libssl-dev mtools rsync u-boot-tools bc python cpio zip unzip file wget flex bison libidn11-dev

   ```
2. Install Vivado 2019.1 from https://www.xilinx.com/support/download.html. Make sure that you install the correct version of Vivado, the current supported version is 2019.1

3. Clone this repo

4. Download the source code:
   ```
   cd plutoplusdvb
   git submodule update --init --recursive
   ```

5. Run the patch.sh script to apply diffs to each submodule
   ```
   scripts/patch.sh
   ```
   If any patches fail to apply, please let me know as compiling will likely fail

6. Configure paths and add DVB support (assumes Vivado is installed in default location of /tools/Vivado):
   ```
   source datvplutofrm/sourceme.ggm
   ```

7. Build the code:
   ```
   cd ..\plutosdr-fw
   make
   ```

8. Once complete, firmware is located in build directory

In the event of any errors, please search the internet on PlutoSDR firmware build. It is identical.

To update your repo to the latest version, you must first revert the patches, run the update and then apply the latest patches as follows:
```
scripts/revert.sh
git pull
git submodule update --recursive
scripts/apply.sh
```


## Jumpers and Pinouts

There is description on PCB on the jumpers.

![Jumpers](./images/jumpers.jpg)

*Please note that all IO levels are 1.8V.*

1. When using the official ADI-PlutoSDR firmware, please connect to URST-MI052.
2. When using Pluto+ firmware and need to support Ethernet, please connect URST-MIO46
3. When using SD card to boot, please connect SD-H to 1V8
4. When using JTAG to debug, please connect JTAG# to GND
5. Please connect EXCLK to GND when using external reference clock input

## HowTo

### How to connect PTT

PTT drives optocouplers through GPIO0 (MI00), which requires an external relay or control circuit.

![ptt_sch](./images/PTT_SCH.jpg)

![ptt](./images/ptt.jpg)

### How to Enter DFU

1. Remove the screws and open up the device.
2. Short URST with MIO52, see the Jumper images for details.
3. Press DFU while power the device

![img](./images/dfu.jpg)

### How to have a external reference clock

You can connect a cable to input an external high-precision reference clock for AD9363 through the IPEX interface.
The main level should not exceed **3.3V**, and the EXCLK jumper needs to be connected to GND to turn off the built-in clock. (Check Jumper image for details)

![img](./images/ref.jpg)

![img](./images/ref_sch.jpg)

### How to Calibrate the OSC

The frequency of the 40M clock can be fine-tuned by adjusting the adjustable resistor next to the VCTCXO. You need to have a reference signal source and frequency meter when adjusting.

### How to boot from SD Card

Connect SD-H jumper to 1V8. Check Jumper image for details. We don't have SD image yet. And we will support it later.
