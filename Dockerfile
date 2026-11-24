# Jantt on Railway: builds the upstream Jantt web app from a pinned release
# and serves it with nginx on $PORT.
#
# Upstream publishes no container image, so we build the release tag ourselves.
# To update: change JANTT_VERSION and JANTT_COMMIT (the tag's commit) below,
# add a CHANGELOG.md entry, and merge to main.

# 1. Source: the upstream release tag, checked against its commit hash.
FROM alpine/git:v2.54.1@sha256:29cff25811f790b9f72fc266bf8009a5a911714c0e03c31c47339c50909d9aef AS source
ARG JANTT_VERSION=v1.1.0
ARG JANTT_COMMIT=681afeca46dab66fd88da0c5ceeb1bf8b68db4b6
RUN git clone --quiet --depth 1 --branch "$JANTT_VERSION" https://github.com/AhmadHassan-BTed/Jantt.git /src \
 && test "$(git -C /src rev-parse HEAD)" = "$JANTT_COMMIT" \
 && rm -r /src/.git

# 2. Build the web app (the "playground") and the packages it imports.
FROM node:22.23.5-alpine@sha256:1314fb30ec37592d5845e5a160d522c0e680972aa534549940b8d73bde88481a AS builder
WORKDIR /app
ENV CI=true NODE_OPTIONS=--max-old-space-size=2048
COPY --from=source /src/ ./
RUN npm ci --no-audit --no-fund --loglevel=error
RUN npm run build --workspace=@jantt/core \
 && npm run build --workspace=@jantt/interop \
 && npm run build --workspace=@jantt/render-canvas \
 && npm run build --workspace=@jantt/react \
 && npm run build --workspace=@jantt/playground \
 && test -f apps/playground/dist/index.html

# 3. Serve it.
FROM nginx:1.30.8-alpine@sha256:6437a63b5c529f0e06162b3f593c0154cff6fa2ea0f94fd7c27928cb399e022d
ENV PORT=8080 \
    NGINX_ENVSUBST_FILTER=^PORT$
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf.template /etc/nginx/templates/default.conf.template
COPY --from=builder /app/apps/playground/dist /usr/share/nginx/html
EXPOSE 8080
STOPSIGNAL SIGQUIT
CMD ["nginx", "-g", "daemon off;"]
