# Etapa 1: Builder
FROM node:20-alpine AS builder
WORKDIR /app

# Habilitar pnpm vía corepack
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copiar archivos de dependencias
COPY package.json pnpm-lock.yaml* ./

# Instalar todas las dependencias (incluyendo devDependencies para compilar)
RUN pnpm install --frozen-lockfile

# Copiar el código fuente y compilar
COPY . .
RUN pnpm run build --if-present

# Etapa 2: Runner (Producción limpia)
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

# Habilitar pnpm también en el runner para instalar dependencias de producción
RUN corepack enable && corepack prepare pnpm@latest --activate

COPY package.json pnpm-lock.yaml* ./

# Instalar únicamente dependencias de producción
RUN pnpm install --prod --frozen-lockfile

# Copiar archivos compilados desde la etapa builder
COPY --from=builder /app/dist ./dist

USER node
EXPOSE 3000

CMD ["node", "dist/index.js"]