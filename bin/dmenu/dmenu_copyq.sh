#!/bin/bash

copyq_list=$(copyq list | sed 's/\t.*//')
selected=$(echo "$copyq_list" | dmenu -i -l 10 -p "Clipboard History:")

if [ -n "$selected" ]; then
    copyq select "$selected"
fi
