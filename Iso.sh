#!/bin/bash

# Ensuring the script is run with root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Variables
USB_DEVICE="/dev/sdx"  # Replace /dev/sdx with your actual USB device
ISO_PATH="/path/to/arch.iso"  # Path to the Arch Linux ISO
ISO_SIZE=$(du -m "$ISO_PATH" | cut -f1)  # Size of the ISO in MB
DEFAULT_EFI_SIZE="+512M"  # Default EFI partition size
DEFAULT_ARCH_SIZE="+"$(($ISO_SIZE + 1024))"M"  # Default Arch partition size, ISO size + 1GB

echo "Detected ISO size: $ISO_SIZE MB"

# User inputs for partition sizes
read -p "Enter EFI partition size (default is 512M): " EFI_SIZE
EFI_SIZE=${EFI_SIZE:-$DEFAULT_EFI_SIZE}

read -p "Enter Arch Linux partition size (default is ISO size + 1GB, $DEFAULT_ARCH_SIZE): " ARCH_PARTITION_SIZE
ARCH_PARTITION_SIZE=${ARCH_PARTITION_SIZE:-$DEFAULT_ARCH_SIZE}

# User input for USB device (with validation)
read -p "Enter your USB device (e.g., /dev/sdx): " INPUT_USB_DEVICE
if [ -b "$INPUT_USB_DEVICE" ]; then
    USB_DEVICE="$INPUT_USB_DEVICE"
else
    echo "Invalid device: $INPUT_USB_DEVICE"
    exit 1
fi

# Confirm operation
echo "This will format $USB_DEVICE and create the following partitions:"
echo "EFI Partition: $EFI_SIZE"
echo "Arch Partition: $ARCH_PARTITION_SIZE"
read -p "Are you sure you want to continue? (y/N): " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "Operation canceled."
    exit 1
fi

# Unmount the device if it's currently mounted
echo "Unmounting the device..."
umount ${USB_DEVICE}* 2>/dev/null

# Creating partition table and partitions
echo "Creating new GPT partition table and partitions on $USB_DEVICE..."
(
echo g # Create a new empty GPT partition table
echo n # Add a new partition (EFI)
echo   # Default partition number
echo   # Default start of partition
echo $EFI_SIZE 
echo t # Change partition type
echo 1 # EFI type
echo n # Add a new partition (Arch Linux)
echo   # Default partition number
echo   # Default start of partition
echo $ARCH_PARTITION_SIZE
echo w # Write changes
) | fdisk $USB_DEVICE

# Making filesystems
echo "Making filesystems..."
mkfs.vfat -F 32 ${USB_DEVICE}1  # EFI partition
mkfs.ext4 ${USB_DEVICE}2        # Arch Linux partition

# Mounting partitions
EFI_MOUNT="/mnt/efi"
ARCH_MOUNT="/mnt/arch"
mkdir -p $EFI_MOUNT $ARCH_MOUNT
mount ${USB_DEVICE}1 $EFI_MOUNT
mount ${USB_DEVICE}2 $ARCH_MOUNT

# Extracting ISO to the Arch partition
echo "Extracting ISO to the Arch partition..."
mkdir /mnt/iso
mount -o loop $ISO_PATH /mnt/iso
cp -a /mnt/iso/* $ARCH_MOUNT
umount /mnt/iso

# Installing GRUB
echo "Installing GRUB..."
grub-install --target=x86_64-efi --efi-directory=$EFI_MOUNT --boot-directory=$ARCH_MOUNT/boot --removable
grub-mkconfig -o $ARCH_MOUNT/boot/grub/grub.cfg

# Clean up
umount $EFI_MOUNT $ARCH_MOUNT
rmdir /mnt/iso $EFI_MOUNT $ARCH_MOUNT
echo "USB drive is ready with Arch Linux."

# Sync and exit
sync
echo "Script completed successfully."
