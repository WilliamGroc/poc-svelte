FROM oven/bun:1 AS base
WORKDIR /app
ENV NODE_ENV=production
ENV DATABASE_URL=file:local.db

# copy node_modules from temp directory
# then copy all (non-ignored) project files into the image
FROM base AS build
COPY . .
RUN bun install --frozen-lockfile
RUN bun run build

# copy production dependencies and source code into final image
FROM base AS release

COPY --from=build /app/local.db .
COPY --from=build /app/build .

# run the app
EXPOSE 3000

RUN ls
CMD [ "bun", "run", "index.js" ]