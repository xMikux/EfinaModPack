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

#JAVA_PATH=/usr/lib/jvm/java-17-openjdk/bin/java

## Packwiz downloader function

packwiz_installer () {
    if [ ! -f "packwiz-installer-bootstrap.jar" ]; then
      echo "Packwiz installer not found, downloading..."
      if hash wget 2>/dev/null; then
        echo "Using wget to download ${Packwiz_Installer_Version} Packwiz installer"
        wget -O $Packwiz_Installer_Name https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/${Packwiz_Installer_Version}/packwiz-installer-bootstrap.jar
      elif hash curl 2>/dev/null; then
        echo "Using curl to download ${Packwiz_Installer_Version} Packwiz installer"
        curl -o $Packwiz_Installer_Name -L https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/${Packwiz_Installer_Version}/packwiz-installer-bootstrap.jar
      else
        echo "Can't find wget or curl, please download one, and run this script again!"
        exit 1
      fi
    else
      echo "Installer exists, pass..."
    fi
}

## Fabric server downloader function

fabirc_server () {
    if [ ! -f ${Fabric_Launcher_Name} ]; then
      echo "Fabric launcher not found, downloading..."
      if hash wget 2>/dev/null; then
        echo "Using wget to download ${Fabric_Version} Fabric ${Fabric_Launcher} Launcher"
        wget -O $Fabric_Launcher_Name https://meta.fabricmc.net/v2/versions/loader/${Minecraft_Version}/${Fabric_Version}/${Fabric_Launcher}/server/jar
      elif hash curl 2>/dev/null; then
        echo "Using curl to download ${Fabric_Version} Fabric ${Fabric_Launcher} Launcher"
        curl -o $Fabric_Launcher_Name -L https://meta.fabricmc.net/v2/versions/loader/${Minecraft_Version}/${Fabric_Version}/${Fabric_Launcher}/server/jar
      else
        echo "Can't find wget or curl, please download one, and run this script again!"
        exit 1
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

packwiz_installer
fabirc_server
packwiz_updater
fabric_start
