FROM node:18-alpine
RUN apk add --no-cache bash curl ca-certificates wget

# 自动识别架构，防止手动改错导致构建失败
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "arm64" ]; then \
      wget --tries=5 --timeout=60 -qO- https://github.com/SagerNet/sing-box/releases/download/v1.9.0/sing-box-1.9.0-linux-arm64.tar.gz | tar -xz && mv sing-box-1.9.0-linux-arm64/sing-box /usr/local/bin/; \
    else \
      wget --tries=5 --timeout=60 -qO- https://github.com/SagerNet/sing-box/releases/download/v1.9.0/sing-box-1.9.0-linux-amd64.tar.gz | tar -xz && mv sing-box-1.9.0-linux-amd64/sing-box /usr/local/bin/; \
    fi

WORKDIR /app
COPY . .
RUN chmod +x start.sh
CMD ["sh", "start.sh"]
