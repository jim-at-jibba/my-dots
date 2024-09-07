#!/bin/bash

gum input | xargs -I {} yt {} | fabric --pattern extract_wisdom
