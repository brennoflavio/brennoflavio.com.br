set -e

hugo -D
scp -r public/* root@server.brennoflavio.lc:/var/www/brennoflavio.com.br
ssh root@server.brennoflavio.lc 'service nginx restart'
