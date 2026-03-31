#######################################
# Build stage
#######################################
FROM node:22 AS builder

WORKDIR /app

# Copy lockfile + manifest first (maximizes layer cache for installs)
COPY package.json pnpm-lock.yaml ./

# Enable pnpm and install deps
RUN corepack enable && pnpm install --frozen-lockfile

# Copy source AFTER install (code changes only invalidate from here down)
COPY . .

# Build the app
RUN pnpm build

# Prune dev deps for the serve stage
RUN pnpm prune --prod

#######################################
# Serve stage
#######################################
FROM node:22-slim

WORKDIR /app

COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/build ./build

EXPOSE 3000

CMD ["node", "/app/build/index.js"]