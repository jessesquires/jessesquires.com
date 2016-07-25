#!/bin/bash

if [ "$#" -ne 2 ]; then
   echo "💥: expected 2 parameters"
   echo "Usage: $0 <YYYY-MM-DD> <TITLE>"
   exit 1
fi

if [[ ! ($1 =~ ^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$) ]]; then
    echo "💥: param 1, date, should be valid date format YYYY-MM-DD. Found '$1'"
    exit 1
fi

if [[ ! ($2 =~ ^[A-Za-z0-9\-]+$) ]]; then
    echo "💥: param 2, title, should be alphanumeric with dashes. Found '$2'"
    exit 1
fi

mkdir -p "_drafts"

POST="_drafts/$1-$2.md"
touch $POST

echo "---
layout: post
title:
subtitle:
---

<!--excerpt-->
" > $POST

echo "Successfully created '$POST'"
echo "Opening..."
open $POST
