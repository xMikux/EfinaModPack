#!/bin/sh

##################################
### Simple Server Start Script ###
######### Author: Efina ##########
##################################

# Setup basic environment

## Fabirc env
Minecraft_Version=1.19.2
Fabric_Version=0.14.9
Fabric_Launcher=0.11.0
Fabric_Launcher_Name=fabric-server-mc.${Minecraft_Version}-loader.${Fabric_Version}-launcher.${Fabric_Launcher}.jar

## Packwiz env
Packwiz_ServerPack_URL=https://raw.githubusercontent.com/xMikux/EfinaModPack/main/ServerPack/pack.toml
Packwiz_Installer_Version=v0.0.3
Packwiz_Installer_Name=packwiz-installer-bootstrap.jar

## Server memory settings

Max_Ram=4G

# If need to setup Java runtime path, set an environment variable with name JAVA_PATH

# JAVA_PATH=/usr/lib/jvm/java-17-openjdk/bin/java

## Command checker

command_checker () {
    echo "Checking available download command..."
    if hash wget 2>/dev/null; then
      echo "Command wget find!! Using this for default download command."
      command_var=0
    elif hash curl 2>/dev/null; then
      echo "Command curl find!! Using this for default download command."
      command_var=1
    else
      echo "Can't find wget or curl. Please install one of package and run this script again!"
      command_var=2
      exit 1
    fi

    echo "Checking java command is exist..."
    if hash java 2>/dev/null; then
      echo "Java installed."
    else
      echo "Java command not found, please install java and run this script again!"
      exit 1
    fi

    # If you don't need version check, you can remove below line.
    echo "Checking java version"
    version=$("${JAVA_PATH:-java}" -version 2>&1 | head -1 | cut -d'"' -f2 | sed '/^1\./s///' | cut -d'.' -f1)
    if [ "$version" -eq "17" ]; then
      echo "Java 17 installed"
    else
      echo "Your java version below 17!"
      echo "Please upgrade your java version or setup the path in this script environment variable."
      echo "And run this script again."
      exit 1
    fi
}

## Packwiz downloader function

packwiz_installer () {
    if [ ! -f $Packwiz_Installer_Name ]; then
      echo "Packwiz installer not found, downloading..."
      if [ $command_var -eq 0 ]; then
        wget -O $Packwiz_Installer_Name https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/${Packwiz_Installer_Version}/packwiz-installer-bootstrap.jar
      elif [ $command_var -eq 1 ]; then
        curl -o $Packwiz_Installer_Name -L https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/${Packwiz_Installer_Version}/packwiz-installer-bootstrap.jar
      fi
    else
      echo "Installer exists, pass..."
    fi
}

## Fabric server downloader function

fabirc_server () {
    if [ ! -f ${Fabric_Launcher_Name} ]; then
      echo "Fabric launcher not found, downloading..."
      if [ $command_var -eq 0 ]; then
        wget -O $Fabric_Launcher_Name https://meta.fabricmc.net/v2/versions/loader/${Minecraft_Version}/${Fabric_Version}/${Fabric_Launcher}/server/jar
      elif [ $command_var -eq 1 ]; then
        curl -o $Fabric_Launcher_Name -L https://meta.fabricmc.net/v2/versions/loader/${Minecraft_Version}/${Fabric_Version}/${Fabric_Launcher}/server/jar
      fi
    else
      echo "Launcher exists, pass..."
    fi
}

## Packwiz Auto Updater

packwiz_updater () {
    echo "Update or download ServerPack..."
    "${JAVA_PATH:-java}" -jar packwiz-installer-bootstrap.jar -g -s server $Packwiz_ServerPack_URL
}

## Fabric Start

fabric_start () {
    echo "All finish... Starting Server!"
    "${JAVA_PATH:-java}" -Xmx${Max_Ram} -jar ${Fabric_Launcher_Name} nogui
}

# Main

command_checker
packwiz_installer
fabirc_server
packwiz_updater
fabric_start
