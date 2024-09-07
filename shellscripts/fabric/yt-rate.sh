#!/bin/bash

# Run fabric -l and pipe the output to gum select
gum input | xargs -I {} yt {} | fabric --pattern rate_content
