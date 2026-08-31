FROM node:18-alpine

# 直接从 sing-box 官方镜像里拷贝二进制文件，完全避开外网下载卡死问题
COPY --from=ghcr.io/sagernet/sing-box:1.9.0 /usr/local/bin/sing-box /usr/local/bin/sing-box

WORKDIR /app
COPY . .

RUN chmod +x start.sh
CMD ["sh", "start.sh"]
