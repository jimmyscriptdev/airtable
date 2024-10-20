#!/usr/bin/bash
#
# Script Name: airtable-mvg-monitoring.sh
# Creation Date: 2024-10-20
# Author: Jimmy (jimmy.scriptdev@gmail.com)
#
# Description:
# Automates data collection to Airtable database
#
# Copyright (c) 2024 jimmy.scriptdev. All rights reserved.
# This script is licensed under the MIT License. You may use, distribute, and modify this code
# under the terms of the MIT license.
#
# Version History:
# -----------------------------------------------------------------------------------------
# Version  |   Date       |  Author       |  Description
# -----------------------------------------------------------------------------------------
# 1.0      | 2024-10-20   |  Jimmy        | Initial creation of the script.
# -----------------------------------------------------------------------------------------

__APIKEY="patXXXXXXXXXXXXXXXXXXXXXXXXXXXXXZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
__DATABASE="appXXXXXXXXXX"
__TABLE="Table%201"
__HOST=$(hostname)

function __checkid {
local __GETID=$(curl "https://api.airtable.com/v0/$__DATABASE/$__TABLE?maxRecords=100&view=Grid%20view" -H "Authorization: Bearer $__APIKEY" 2>&1| tr ',' '\n'|grep -B3 -w "$__HOST"|grep '"id"'|sed s/'\"records\":'//g|awk -F":" '{print $2}'|sed s/'"'//g)
echo $__GETID
}

function __create {
        curl -X POST https://api.airtable.com/v0/$__DATABASE/$__TABLE -H "Authorization: Bearer $__APIKEY" -H "Content-Type: application/json" --data "{ \"records\": [ { \"fields\": { \"Name\": \"$__HOST\", \"Notes\": \"$(uptime)\" } } ] }" > /dev/null 2>&1
}

function __patch {
        curl -X PATCH https://api.airtable.com/v0/$__DATABASE/$__TABLE -H "Authorization: Bearer $__APIKEY" -H "Content-Type: application/json" --data "{\"records\": [{ \"id\": \"$(__checkid)\",\"fields\": { \"Name\": \"$__HOST\",\"Notes\": \"$(uptime)\" } } ] }" > /dev/null 2>&1
}

if [[ -z $(__checkid) ]]; then
        echo "No entry found, creating"
        __create
else
        echo "Updating record"
        __patch
fi
