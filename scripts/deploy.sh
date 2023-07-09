set -e

hugo -D
scp -r public/* root@192.168.0.5:/usr/local/www/nginx
ssh root@192.168.0.5 'service nginx restart'
