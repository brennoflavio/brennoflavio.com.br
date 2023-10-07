set -e

hugo -D
scp -r public/* root@nginx.brennoflavio.lc:/usr/local/www/nginx
ssh root@nginx.brennoflavio.lc 'service nginx restart'
