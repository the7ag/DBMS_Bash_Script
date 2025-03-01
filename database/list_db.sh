#!/bin/bash
source config.sh

echo "Available databases:"
psql -lqt | cut -d \| -f 1 | sed '/^\s*$/d'
