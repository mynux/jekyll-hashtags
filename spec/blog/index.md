---
layout: default
title: I'm a page
regenerate: true
tags:
  - one
  - two
  - three
---

test #AmazonGo test #again #once-more

<ul>
  {% for tag in page.tags %}
    <li>{{ tag }}</li>
  {% endfor %}
</ul>
