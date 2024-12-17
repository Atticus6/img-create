

FROM node:20-bullseye

RUN apt-get update


# 设置工作目录
WORKDIR /app

# 复制代码到容器
COPY . .


# 安装 Puppeteer 依赖和中文字体
RUN apt-get install -y  \
    gconf-service \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libxcomposite1 \
    libxrandr2 \
    libxdamage1 \
    libxext6 \
    libnss3 \
    libnspr4 \
    libgdk-pixbuf2.0-0 \
    libxss1 \
    libgtk-3-0 \
    libgbm1 \
    fonts-liberation \
    libasound2 \
    xdg-utils \
    libappindicator1 \
    fonts-wqy-zenhei \
    fonts-wqy-microhei \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*




COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* .npmrc* ./
RUN \
  if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
  elif [ -f package-lock.json ]; then npm ci; \
  elif [ -f pnpm-lock.yaml ]; then corepack enable pnpm && pnpm i --frozen-lockfile; \
  else echo "Lockfile not found." && exit 1; \
  fi


RUN npx puppeteer browsers install chrome


# 暴露端口
EXPOSE 19000

# 启动命令
CMD ["node", "app.js"]
