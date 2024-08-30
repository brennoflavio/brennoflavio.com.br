---
title: "Simple fix for Rspamd false positives"
date: 2024-08-30T11:13:00-03:00
draft: false
type: post
---

During the past months I've been dealing with a lot of emails from differnt sources being flagged as Spam. This almost made me to turn rspamd in my self hosted setup. But upon further investigation, I found that the my setup was not considering my Spam directives correctly.

For example, this is how it looked like for the Spam classification for a given legit email:

```
BAYES_HAM (-3) [100.00%]
VIOLATED_DIRECT_SPF (3.5)
HTML_SHORT_LINK_IMG_1 (2)
CTYPE_MIXED_BOGUS (1)
R_SPF_FAIL (1) [-all:c]
DMARC_POLICY_ALLOW_WITH_FAILURES (-0.5)
FORGED_SENDER (0.3) []
MIME_HTML_ONLY (0.2)
R_DKIM_ALLOW (-0.2) []
MIME_GOOD (-0.1) [multipart/mixed]
MANY_INVISIBLE_PARTS (0.05) [1]
MX_GOOD (-0.01) []
DMARC_POLICY_ALLOW (0) []
DKIM_TRACE (0) []
REDIRECTOR_URL (0) []
MIME_TRACE (0) [0:+,1:~]
DWL_DNSWL_NONE (0) []
ARC_NA (0)
TO_DN_NONE (0)
FROM_HAS_DN (0)
RCVD_COUNT_ZERO (0) [0]
RCPT_COUNT_ONE (0) [1]
TO_MATCH_ENVRCPT_ALL (0)
FROM_NEQ_ENVFROM (0) []
ASN (0) [asn:16509, ipnet:54.233.128.0/17, country:US]
```

Final pontuation is -2.24, so it is flagged as Spam.

By changing the BAYES_HAM flag in the UI from -3 to -6, my false positive Spam problems went away.
