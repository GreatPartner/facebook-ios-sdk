#!/bin/sh
# Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
#
# You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
# copy, modify, and distribute this software in source code or binary form for use
# in connection with the web services and APIs provided by Facebook.
#
# As with any software that integrates with the Facebook platform, your use of
# this software is subject to the Facebook Developer Principles and Policies
# [http://developers.facebook.com/policy/]. This copyright notice shall be
# included in all copies or substantial portions of the software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# shellcheck disable=SC2039
# shellcheck disable=SC1090

# --------------
# Functions
# --------------

# Main
main() {
  TEST_FAILURES=$((0))

  test_shared_setup
  test_build_sdk

  case $TEST_FAILURES in
    0) test_success "test_scripts tests" ;;
    *) test_failure "$TEST_FAILURES test_scripts tests" ;;
  esac
}

# Test Success
test_success() {
  local green='\033[0;32m'
  local none='\033[0m'
  echo "${green}* Passed:${none} $*"
}

# Test Failure
test_failure() {
  local red='\033[0;31m'
  local none='\033[0m'
  echo "${red}* Failed:${none} $*"
}

# Test Shared Setup
test_shared_setup() {

  # Arrange
  local test_sdk_kits=(
    "FBSDKCoreKit"
    "FBSDKLoginKit"
    "FBSDKShareKit"
    "FBSDKPlacesKit"
    "FBSDKMarketingKit"
    "FBSDKTVOSKit"
    "AccountKit"
  );

  local test_pod_specs=(
    "FacebookSDK"
    "FBSDKCoreKit"
    "FBSDKLoginKit"
    "FBSDKShareKit"
    "FBSDKPlacesKit"
    "FBSDKMarketingKit"
    "FBSDKTVOSKit"
    "AccountKit"
  );

  if [ ! -f "$PWD/scripts/run.sh" ]; then
    test_failure "You're not in the correct working directory. Please change to the scripts/ parent directory"
  fi

  # Act
  . "$PWD/scripts/run.sh"

  # Assert
  if [ -z "$SCRIPTS_DIR" ]; then
    test_failure "SCRIPTS_DIR"
    ((TEST_FAILURES+=1))
  fi

  if [ "$SCRIPTS_DIR" != "$SDK_DIR"/scripts ]; then
    test_failure "SCRIPTS_DIR not correct"
    ((TEST_FAILURES+=1))
  fi

  if [ "${SDK_KITS[*]}" != "${test_sdk_kits[*]}" ]; then
    test_failure "SDK_KITS not correct"
    ((TEST_FAILURES+=1))
  fi;

  if [ "${POD_SPECS[*]}" != "${test_pod_specs[*]}" ]; then
    test_failure "POD_SPECS not correct"
    ((TEST_FAILURES+=1))
  fi;

  if [ "$FRAMEWORK_NAME" != "FacebookSDK" ]; then
    test_failure "FRAMEWORK_NAME not correct"
    ((TEST_FAILURES+=1))
  fi
}

# Test Build SDK
test_build_sdk() {
  # Arrange
  local actual

  # Act
  actual=$(sh "$PWD"/scripts/run.sh build unsupported)

  # Assert
  if [ "$actual" != "Unsupported Build" ]; then
    test_failure "build_sdk not correct"
    ((TEST_FAILURES+=1))
  fi
}

# --------------
# Main Script
# --------------

main "$@"