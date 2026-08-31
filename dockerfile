FROM node:18-alpine
RUN apk add --no-cache bash curl ca-certificates wget
# 写死Linux AMD64架构，加快识别速度；增加超时和重试，防止网络卡死
RUN wget --timeout=120 --tries=10 --retry-connrefused -qO- https://github.com/SagerNet/sing-box/releases/download/v1.9.0/sing-box-1.9.0-linux-amd64.tar.gz | tar -xz \
    && mv sing-box-1.9.0-linux-amd64/sing-box /usr/local/bin/ \
    && rm -rf sing-box-1.9.0-linux-amd64
WORKDIR /app
COPY . .
RUN chmod +x start.sh
CMD ["sh", "start.sh"]
