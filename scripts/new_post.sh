#!/bin/bash

echo "Create a new post"
echo ""

while true; do
    read -p "Enter date (YYYY-MM-DD): " YEAR

    if [[ ! ($YEAR =~ ^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$) ]]; then
        echo ""
        echo "💥  invalid: date must have format YYYY-MM-DD. Found '$YEAR'."
        echo ""
    else
        break
    fi
done

while true; do
    read -p "Enter title (alphanumeric with dashes): " TITLE

    if [[ ! ($TITLE =~ ^[A-Za-z0-9\-]+$) ]]; then
        echo ""
        echo "💥  invalid: title must be alphanumeric with dashes. Found '$TITLE'."
        echo ""
    else
        break
    fi
done

echo "Generating new post in _posts/ ...";
POST="_posts/$YEAR-$TITLE.md"
touch $POST

echo "---
layout: post
categories: [software-dev | essays | reading-notes]
tags: [TODO]
date: $YEAR T10:00:00-07:00
title: $TITLE
subtitle: null
image:
    file: TODO
    alt: TODO
    caption: null
    source_link: null
    half_width: false
---

> TODO: excerpt here

<!--excerpt-->

{% include post_image.html %}

> TODO: content here

<!-- image example -->

{% include image.html
    file=TODO
    alt=TODO
    caption=null
    source_link=null
    half_width=false
%}

<!-- break -->

{% include break.html %}

<!--
handling links

posts: [link]({{ site.url }}{% post_url 2000-01-01-my-blog-post-title %})

images: {{ site.url }}{{ site.img_url}}/path-to/image.png
-->

" > $POST

echo "Successfully created '$POST'"
echo "Opening..."
echo ""
open $POST
