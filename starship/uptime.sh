#!/bin/bash
# echo "[uptime: $(uptime | cut -d " " -f 4,5,6)]"
# echo "🦄🐙 [uptime: $(uptime | cut -d " " -f 4,5 | tr -d ,)]"
echo "[uptime: $(uptime | cut -d " " -f 4,5,6 | tr -d ,)]"

