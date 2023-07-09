---
title: "I'm opening my Searx instance"
date: 2023-07-08T22:56:00-03:00
draft: false
type: post
---

[https://searx.brennoflavio.com.br](https://searx.brennoflavio.com.br)

If you care about your privacy, you've heard of Searx. Its a meta search engine, so when you make a search it routes to many search providers (Google, DuckDuckGo, etc) and return relevant results. [You can learn more here](https://docs.searxng.org/).

Its better than using Google directly because:
- You'll be using the same IP than other people using the same instance
- Searx generates a random profile and sends minimal data to Google, decreasing your footprint.

[You can find a list of public instances here](https://searx.space/). The problem of using one available on my case is that I live in Brazil and the majority of those instances are in either US or Europe, so there is latency in the response. So I was self hosting my own instance for personal use.

Now I'm making a pilot by opening this instance. It does not support heavy traffic, so I won't be listing it in searx site. But feel free to use it as your main search engine.

If you're curious about my setup, this instance runs in a FreeBSD (Truenas) jail, behind a Nginx proxy. I cloned their repo, built the app, and used runit to create a service inside the jail with a configuration [that can be found in my Github](https://github.com/brennoflavio/privacy-frontends-config/blob/master/searx/settings.yml). Those configs are outdated tho, when I have some time I'll create another repo with all my Jails in one place.

If this works I'll open other instances too, like Libreddit, Nitter, etc.

