#!/bin/bash

# set fast fail
set -eo pipefail

ORIGINAL_PWD=$PWD
INSTALLER_LOCAL_DIR=$GITHUB_ACTION_PATH/tmp
INSTALLER_LOCAL_PATH=$INSTALLER_LOCAL_DIR/get-boogie.sh
INSTALLER_URL="https://raw.githubusercontent.com/pontem-network/move/$INP_REF/scripts/dev_setup.sh"

mkdir -p $INSTALLER_LOCAL_DIR

# download the installer
if [ -z $SECRET_TOKEN ]; then
  curl -o "$INSTALLER_LOCAL_PATH" \
      -s $INSTALLER_URL;
else
  curl -o "$INSTALLER_LOCAL_PATH" \
      -H "Authorization: Bearer ${SECRET_TOKEN}" \
      -s $INSTALLER_URL;
fi;

# fix permissions
if [ ! "$RUNNER_OS" == "Windows" ]; then
    sudo chown runner $INSTALLER_LOCAL_PATH && chmod +x $INSTALLER_LOCAL_PATH
fi

# prepare
if [ ! -f rust-toolchain ]; then
  REMOVE_RUST_TOOLCHAIN=true
  touch rust-toolchain
fi

# execute the installer
INSTALL_DIR=$INSTALLER_LOCAL_DIR $INSTALLER_LOCAL_PATH -byp

# post setup
source $HOME/.profile
echo "$HOME/bin" >> $GITHUB_PATH
echo "${DOTNET_ROOT}/tools" >> $GITHUB_PATH
echo "DOTNET_ROOT=${DOTNET_ROOT}" >> $GITHUB_ENV
echo "Z3_EXE=${Z3_EXE}" >> $GITHUB_ENV
echo "BOOGIE_EXE=${BOOGIE_EXE}" >> $GITHUB_ENV
echo "CVC5_EXE=${CVC5_EXE}" >> $GITHUB_ENV
echo "::set-output name=DOTNET_ROOT::$DOTNET_ROOT"
echo "::set-output name=Z3_EXE::$Z3_EXE"
echo "::set-output name=BOOGIE_EXE::$BOOGIE_EXE"
echo "::set-output name=CVC5_EXE::$CVC5_EXE"

# post clean
if [ $REMOVE_RUST_TOOLCHAIN ]; then
  rm rust-toolchain
fi
