set -e

hugo -D
scp -r public/* root@nginx.brennoflavio.lc:/usr/local/www/brennoflavio.com.br
ssh root@nginx.brennoflavio.lc 'service nginx restart'
