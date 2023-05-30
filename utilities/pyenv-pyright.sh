#!/usr/bin/env bash
#
# Summary: Create pyright config file in current directory
#
# Usage: pyenv pyright [virtualenv]
#        pyenv pyright --help
#
#        [virtualenv] should be a Python version known to pyenv.
#
# Create pyright LSP server config file `pyrightconfig.json`
# in current directory, setting its attribute `venv` to
# selected virtualenv and `venvPath` to `PYENV_ROOT/versions`.
# If `pyrightconfig.json` file already exists, update those
# attributes in existing file instead.
#
# Running `pyenv pyright` without arguments, virtualenv
# returned in `pyenv version-name` will be used. This means
# that the script works with venvs set by `.python-version`,
# activated with `pyenv activate` and also `pyenv shell`,
# but won't support regular venv activated.
#
# This plugin also does not support passing a venv path as
# arguments (At least, not yet).
#
# NOTE: This plugin requires `pyenv-virtualenv`
#
# Examples:
#
# - From an activated pyenv virtualenv (set by `pyenv local`
# for example) run `pyenv pyright` to set pyright config file
# to this venv:
#
#  (myvenv) pyenv pyright
#
# - Considering you have a pyenv virtualenv named `myvenv`,
# to set pyright config file to use this virtualenv,
# pass it as argument:
#
#  pyenv pyright myvenv
#

set -e
[ -n "$PYENV_DEBUG" ] && set -x

# Provide pyenv completions
if [ "$1" = "--complete" ]; then
  exec pyenv-virtualenvs --bare
fi

PYRIGHT_FILENAME='pyrightconfig.json'
PYRIGHT_VENV_PATH="$PYENV_ROOT/versions"

create_new_file() {
    pyright_venv=$1
    new_file='{"venvPath":"'$PYRIGHT_VENV_PATH'", "venv":"'$pyright_venv'"}'
    echo $new_file | json_pp > $PYRIGHT_FILENAME
}

get_key() {
    cat $PYRIGHT_FILENAME | json_pp | grep -e "\s*\"${1}\"\s*:\s*\".*\"" -o | grep "\"${1}\"" -o || true
}

update_file_key() {
    key=$1
    value=$2
    has_key=$(get_key $key)
    if [ -z $has_key ]; then
        new_file=$(cat $PYRIGHT_FILENAME | json_pp | sed "s|^{$|{\"$key\":\"$value\"\,|")
    else
        new_file=$(cat $PYRIGHT_FILENAME | json_pp | sed 's|^\s*"'$key'"\s*:\s*".*"|"'$key'":"'$value'"|')
    fi
    echo $new_file | json_pp > $PYRIGHT_FILENAME
}

setup_pyrightconfig_file() {
    pyright_venv=$1

    if [ -e $PYRIGHT_FILENAME ]; then
        if [ -f $PYRIGHT_FILENAME ]; then
            if [ "$(cat $PYRIGHT_FILENAME | json_pp)" = "{}" ]; then
                create_new_file $pyright_venv
            else
                update_file_key "venv" $pyright_venv
                update_file_key "venvPath" $PYRIGHT_VENV_PATH
            fi
        elif [ -d $PYRIGHT_FILENAME ]; then
            echo "pyenv-pyright: '$PYRIGHT_FILENAME' not updated because it is a directory." 1>&2
            exit 1
        else
            echo "pyenv-pyright: '$PYRIGHT_FILENAME' exists but it is not a regular file." 1>&2
            exit 1
        fi
    else
        create_new_file $pyright_venv
    fi
}

version="${1:-$(pyenv-version-name)}"
prefix=$(pyenv-prefix $version 2> /dev/null || true)
if [ ! "$version" = "system" ] && [ ! -z $prefix ] && [ -x "$prefix/bin/python" ] && [ -f "$prefix/bin/activate" ]; then
    setup_pyrightconfig_file $version
else
    if [ -z $1 ]; then
        echo "pyenv-pyright: pyenv virtualenv not found. Inform virtualenv." 1>&2
    else
        echo "pyenv-pyright: '${version}' is not a virtualenv. Inform virtualenv." 1>&2
    fi
    exit 1
fi
