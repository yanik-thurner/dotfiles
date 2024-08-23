#!/bin/bash

if command -v fish &> /dev/null && [ -z "$SKIP_FISH" ]; 
then
    # exit bash whenever fish ends
    fish; exit
fi
