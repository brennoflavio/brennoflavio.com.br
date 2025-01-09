FROM klakegg/hugo:ext as builder

WORKDIR /app

COPY . /app

RUN hugo -D

FROM nginx:alpine

COPY --from=builder /app/public /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
