ARG CADDY_VERSION=2.11.4
ARG VARIANT=""
FROM --platform=$BUILDPLATFORM caddy:${CADDY_VERSION}-builder AS builder

ARG CADDY_VERSION
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    GOARM=${TARGETVARIANT#v} \
    xcaddy build "v${CADDY_VERSION#v}" \
      --with github.com/caddy-dns/desec

FROM caddy:${CADDY_VERSION}${VARIANT}

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
