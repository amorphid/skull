#!/bin/bash

set -eu

Installer.ensure_unique_install () {
  if DUPLICATE=$(which skull); then
    Installer.raise_duplicate_install "${DUPLICATE}"
  fi
}

Installer.create_directory () {
  mkdir -p "$(Installer.get_directory)"
}

# TODO:  Add option to override an existing link
Installer.create_link_to_executable () {
    cd $(dirname "${0}")
    ln -s "$(pwd)""/boot.sh" "$(Installer.get_directory)""/skull"
}

Installer.help () {
  Installer.help_message
  exit 0
}

Installer.help_message () {
  cat <<EOF
Usage: install.sh [options]

options:
  -d, --directory <directory_string>
    * directory into which the "skull" executable is placed
    * default is "/usr/local/bin"
  -h, --help
    * display this help
EOF
}

Installer.initialize () {
  if [[ $@ ]]; then
    Installer.parse_options "${@}"
  fi
}

Installer.install () {
  Installer.ensure_unique_install
  Installer.create_directory
  Installer.create_link_to_executable
  exit 0
}

# TODO:  Write tests for each case
Installer.parse_options () {
  case "${1}" in
    -d|--directory)
      shift
      Installer.set_directory "${1}"
      ;;
    -h|--help)
      Installer.help
      ;;
    *)
      Installer.raise_option_parse_error "${1}"
      ;;
  esac

  shift
  if [[ $@ ]]; then
    Installer.parse_options "${@}"
  fi
}

Installer.raise () {
  echo "[""${0}""] ""${1}" >&2
  exit 1
}

Installer.raise_option_parse_error () {
  Installer.raise "unknown option: ""\"""${1}""\""
}

Installer.raise_duplicate_install () {
  Installer.raise "duplicate install detected: ""\"""${1}""\""
}

Installer.get_directory () {
  echo "${INSTALLER_DIRECTORY:-/usr/local/bin}"
}

Installer.set_directory () {
  INSTALLER_DIRECTORY="${1}"
}

Installer.set_non_interactive () {
  INSTALLER_NON_INTERACTIVE="${1}"
}

Installer.initialize "${@:1}"
Installer.install
