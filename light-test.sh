#!/bin/bash

failures=0
_pwd=`pwd`

err() {
  echo "$@" >&2
}

test-cli-flags() {
  echo 'Running CLI checks'
  cd "$_pwd"
  export PAGER=cat
  ./node-deb --show-readme > /dev/null && \
  ./node-deb --show-changelog > /dev/null || {
    err 'Could not display README or CHANGELOG'
    : $((failures++))
  }
}

test-simple-project() {
  echo "Running tests for simple-project"
  cd "$_pwd/test/simple-project" || die 'cd error'

  declare -i is_success=1
  declare output
  output=$(../../node-deb --no-delete-temp -- app.js lib/)

  if [ "$?" -ne 0 ]; then
    is_success=0
    err "$output"
  fi

  output_dir='simple-project_0.1.0_all/'

  if ! grep -q 'Package: simple-project' "$output_dir/DEBIAN/control"; then
    err 'Package name was wrong'
    is_success=0
  fi

  if ! grep -q 'Version: 0.1.0' "$output_dir/DEBIAN/control"; then
    err 'Package version was wrong'
    is_success=0
  fi

  if [ "$is_success" -eq 1 ]; then
    echo "Success for simple-project"
    rm -rf "$output_dir"
  else
    err "Failure for simple project"
    : $((failures++))
  fi
}

test-cli-flags
test-simple-project
