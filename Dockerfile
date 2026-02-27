FROM oven/bun:1-alpine as base
WORKDIR /app

# Build layer
FROM base as build

COPY bun.lock package.json ./
RUN bun install --frozen-lockfile
COPY . .
RUN bun run build:bun

# Production layer
FROM base as production

EXPOSE 3000
ENV NODE_ENV=production
COPY --from=build /app/.output ./.output

CMD ["bun", "run", ".output/server/index.mjs"]
