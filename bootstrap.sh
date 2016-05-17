#!/bin/bash
set -e

banner() {
  echo "|-----------------------------------------|"
  echo "|--------- ghaiklor-os bootstrap ---------|"
  echo "|-----------------------------------------|"
}

osx() {
  echo "Detected OSX!"
  if [ ! -z "$(which brew)" ]; then
    echo "Homebrew detected! Now updating..."
    brew update
    if [ -z "$(which git)" ]; then
      echo "Now installing git..."
      brew install git
    fi
    if [ -z "$(which qemu-system-i386)" ]; then
      echo "Installing qemu..."
      brew install qemu
    fi
  else
    echo "Homebrew does not appear to be installed! Would you like me to install it?"
    printf "(Y/n): "
    read -r installit
    if [ "$installit" == "Y" ]; then
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
      echo "Will not install, now exiting..."
      exit
    fi
  fi
  echo "Running setup script..."
  brew tap homebrew/versions
  brew install gcc49
  brew tap nashenas88/gcc_cross_compilers
  brew install nashenas88/gcc_cross_compilers/i386-elf-binutils nashenas88/gcc_cross_compilers/i386-elf-gcc nasm
}

archLinux() {
  echo "Detected Arch Linux"
  echo "Updating system..."
  sudo pacman -Syu

  if [ -z "$(which nasm)" ]; then
    echo "Installing nasm..."
    sudo pacman -S nasm
  fi

  if [ -z "$(which git)" ]; then
    echo "Installing git..."
    sudo pacman -S git
  fi

  if [ -z "$(which qemu-system-i386)" ]; then
    echo "Installing QEMU..."
    sudo pacman -S qemu
  fi
}

ubuntu() {
  echo "Detected Ubuntu/Debian"
  echo "Updating system..."
  sudo apt-get update
  echo "Installing required packages..."
  sudo apt-get install build-essential libc6-dev-i386 nasm curl file git libfuse-dev
  if [ -z "$(which qemu-system-i386)" ]; then
    echo "Installing QEMU..."
    sudo apt-get install qemu-system-x86 qemu-kvm
  fi
}

fedora() {
  echo "Detected Fedora"
  if [ -z "$(which git)" ]; then
    echo "Installing git..."
    sudo yum install git-all
  fi
  if [ -z "$(which qemu-system-i386)" ]; then
    echo "Installing QEMU..."
    sudo yum install qemu-system-x86 qemu-kvm
  fi
  echo "Installing necessary build tools..."
  sudo dnf install gcc gcc-c++ glibc-devel.i686 nasm make libfuse-dev
}

suse() {
  echo "Detected a suse"
  if [ -z "$(which git)" ]; then
    echo "Installing git..."
    zypper install git
  fi
  if [ -z "$(which qemu-system-i386)" ]; then
    echo "Installing QEMU..."
    sudo zypper install qemu-x86 qemu-kvm
  fi
  echo "Installing necessary build tools..."
  sudo zypper install gcc gcc-c++ glibc-devel-32bit nasm make libfuse
}

gentoo() {
  echo "Detected Gentoo Linux"
  if [ -z "$(which nasm)" ]; then
    echo "Installing nasm..."
    sudo emerge dev-lang/nasm
  fi
  if [ -z "$(which git)" ]; then
    echo "Installing git..."
    sudo emerge dev-vcs/git
  fi
  echo "Installing fuse..."
  sudo emerge sys-fs/fuse
  if [ -z "$(which qemu-system-i386)" ]; then
    echo "Please install QEMU and re-run this script"
    echo "Step1. Add QEMU_SOFTMMU_TARGETS=\"i386\" to /etc/portage/make.conf"
    echo "Step2. Execute \"sudo emerge app-emulation/qemu\""
  fi
}

endMessage() {
  echo
  echo "|-----------------------------------------|"
  echo "| Well it looks like you are ready to go! |"
  echo "|-----------------------------------------|"
  echo "| make                                    |"
  echo "| make run                                |"
  echo "|-----------------------------------------|"
  echo "|-------------- Good luck! ---------------|"
  echo "|-----------------------------------------|"
  exit
}

banner
if [ "Darwin" == "$(uname -s)" ]; then
  osx
else
  # Arch linux
  if hash 2>/dev/null pacman; then
    archLinux
  fi
  # Debian or any derivative of it
  if hash 2>/dev/null apt-get; then
    ubuntu
  fi
  # Fedora
  if hash 2>/dev/null yum; then
    fedora
  fi
  # Suse and derivatives
  if hash 2>/dev/null zypper; then
    suse
  fi
  # Gentoo
  if hash 2>/dev/null emerge; then
    gentoo
  fi
fi
endMessage
