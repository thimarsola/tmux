#!/bin/bash

read -p "query: " query

tmux neww bash -c "curl cht.sh/laravel/`echo $query | tr ' ' '+'` & while [ : ]; do sleep 1; done"
