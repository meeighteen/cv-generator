FROM node:20-alpine
WORKDIR /app

ENV NODE_ENV=production

# Habilitar pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copiar dependencias e instalarlas en modo producción
COPY package.json pnpm-lock.yaml* ./
RUN pnpm install --prod --frozen-lockfile

# Copiar el resto del código
COPY . .

USER node
EXPOSE 3000

# Ajusta el archivo principal según corresponda (ej. index.js, app.js o src/index.js)
CMD ["node", "index.js"]