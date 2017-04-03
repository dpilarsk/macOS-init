#!/usr/bin/env bash

set -x
# Update brew and upgrade all packages
brew update
brew outdated
brew upgrade
brew cleanup
brew doctor
brew prune

# Clean Cask cache
brew cask cleanup

set +x

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

# List all casks and for each of them,
# test if a newer version is available.
casks=( $(brew cask list) )
for cask in ${casks[@]}
do
    version=$(brew cask info $cask | sed -n "s/$cask:\ \(.*\)/\1/p")
    installed=$(find "/usr/local/Caskroom/$cask" -type d -maxdepth 1 -maxdepth 1 -name "$version")

    if [[ -z $installed ]]; then
        echo "${red}${cask}${reset} requires ${red}update${reset}."
        (set -x; brew cask uninstall $cask --force;)
        (set -x; brew cask install $cask --force;)
    else
        echo "${red}${cask}${reset} is ${green}up-to-date${reset}."
    fi
done