#!/bin/bash

aslVersion=$(cat /etc/asl_version)

echo -e "
┌───────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                       │
│  █████  ██      ██      ███████ ████████  █████  ██████  ██      ██ ███    ██ ██   ██ │
│ ██   ██ ██      ██      ██         ██    ██   ██ ██   ██ ██      ██ ████   ██ ██  ██  │
│ ███████ ██      ██      ███████    ██    ███████ ██████  ██      ██ ██ ██  ██ █████   │
│ ██   ██ ██      ██           ██    ██    ██   ██ ██   ██ ██      ██ ██  ██ ██ ██  ██  │
│ ██   ██ ███████ ███████ ███████    ██    ██   ██ ██   ██ ███████ ██ ██   ████ ██   ██ │
│                                                                                       │
│                                                                                       │
│        ██████  ███████ ████████  █████        ██████     ██████     ██████            │
│        ██   ██ ██         ██    ██   ██            ██   ██  ████   ██  ████           │
│        ██████  █████      ██    ███████ █████  █████    ██ ██ ██   ██ ██ ██           │
│        ██   ██ ██         ██    ██   ██       ██        ████  ██   ████  ██           │
│        ██████  ███████    ██    ██   ██       ███████ ██ ██████  ██ ██████            │
│                                                                                       │
│        By: Jim WB6NIL (SK), Steve N4IRS, Adam KC1KCC, Rob KK9ROB, and others          │
│                            https://www.allstarlink.org                                │
│                           (C) 1999 - 2005, Digium, Inc                                │
│                          (C) 2018-2021 AllStarLink, Inc                               │
└───────────────────────────────────────────────────────────────────────────────────────┘
You may access this machine via SSH via the following hosts:

$(hostname)
$(hostname).local
$(hostname -I | awk '{print $1}')

ASL Version ${aslVersion}
" > /etc/motd

cat /etc/motd > /etc/issue

exit 0
