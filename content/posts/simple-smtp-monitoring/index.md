---
title: "Simple Monitioring tool for URLs using SMTP"
date: 2023-09-10T00:18:45-03:00
draft: false
type: post
---

[Github Repo](https://github.com/brennoflavio/simple-smtp-monitoring)

After getting frustrated that [Kuma](https://github.com/louislam/uptime-kuma), a tool for monitoring
applications cannot run on FreeBSD due to [unsupported Node dependencies](https://github.com/microsoft/playwright/issues/20330),
I decided to write a simple Python script to check some of my services and email me in case I'm wrong.

This script only uses the standard library, so it should be able to run in any environment. Just make sure your python
distribution have sqlite support, fill in the configuration file and run it using cron job.

I configure the jobs the following way (in a freebsd jail):
```
0 */2 * * * /usr/local/bin/python3 /root/simple-smtp-monitoring/main.py --type regular
0 0 * * * /usr/local/bin/python3 /root/simple-smtp-monitoring/main.py --type resume
```

This way it will check each url every 2 hours, and at end of each day it will report
the result to me.

What it does? It has a string check if it should use `urllib` or `telnetlib`, and opens a connection
to the url (GET requests and telnet open command). If everything goes correctly, it logs the result,
and with fails it sends an email.
