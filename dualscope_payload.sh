#!/bin/bash
if [ -f /tmp/start_dualscope ]; then
    rm /tmp/start_dualscope

    sudo /usr/local/bin/dualscope/dualscope.sh

    return-to-gamemode
fi
