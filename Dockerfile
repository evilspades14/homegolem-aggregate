#######################################
# Build stage
#######################################
FROM node:22 AS builder

WORKDIR /app

# Install pnpm
# ENV PNPM_HOME="/pnpm"
# ENV PNPM_STORE_DIR="/pnpm/store"
# ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable && pnpm config set store-dir "$PNPM_STORE_DIR"

# Install package dependencies (cache first)
COPY package.json pnpm-lock.yaml ./
RUN --mount=type=cache,target=/pnpm/store pnpm install --frozen-lockfile

# copy remaining files
COPY . /app

# build app
RUN pnpm build
RUN pnpm prune --prod

#######################################
# Serve stage
#######################################
FROM node:22-slim

WORKDIR /app

COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/node_modules /app/node_modules
COPY --from=builder /app/build /app/build

EXPOSE 3000

CMD ["node", "/app/build/index.js"]