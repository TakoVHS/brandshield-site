---
layout: page
title: "Brandshield Blog"
description: "Insights on brand protection, threat intelligence, and defensive security strategies."
permalink: /blog/
---

<div class="hero">
  <div class="card">
    <div class="kicker">Resources</div>
    <div class="h1">Brandshield Blog</div>
    <p class="lead">
      Статьи, кейсы и insights по защите бренда от фишинга и имперсонации.
    </p>
  </div>
</div>

<div style="margin-top: 3rem;">
  {% for post in site.posts %}
  <div class="card" style="margin-bottom: 2rem; padding: 1.5rem; border: 1px solid #eee; border-radius: 8px;">
    <div class="kicker">{{ post.date | date: "%d %B %Y" }}</div>
    <h2 style="margin: 0.5rem 0;">
      <a href="{{ post.url }}" style="color: inherit; text-decoration: none;">{{ post.title }}</a>
    </h2>
    <p class="lead" style="margin: 0.5rem 0; color: #666;">{{ post.excerpt | strip_html | truncate: 150 }}</p>
    <a href="{{ post.url }}" class="btn btn--ghost" style="font-size: 0.85rem;">Read More →</a>
  </div>
  {% endfor %}

  {% if site.posts.size == 0 %}
  <div class="card">
    <p class="small" style="color: #999; text-align: center;">
      Статьи скоро появятся. Subscribe to RSS для обновлений.
    </p>
  </div>
  {% endif %}
</div>

<div style="margin-top: 3rem; padding-top: 2rem; border-top: 1px solid #eee;">
  <h2>Subscribe</h2>
  <p class="small">
    Подпишись на RSS для получения обновлений:
    <a href="{{ site.baseurl }}/feed.xml">RSS Feed</a>
  </p>
</div>
