FROM python:3.8.13-alpine as base

WORKDIR /work

RUN apk add libpq-dev \
    && pip install wheel \
    && pip install --upgrade httpie \
    && http --version \
    && rm -rf /var/cache/apk/*
