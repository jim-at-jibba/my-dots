#!/bin/bash

printf "Setting up Adeleie WOP dev envirnoment"

printf "Setting NODE_ENV to develop"
export NODE_ENV='development'

printf "Setting ADELIE_CONTROL_NODE to true"
export ADELIE_CONTROL_NODE='true'

printf "Finished setting VARS"
