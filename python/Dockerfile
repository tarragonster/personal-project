FROM python:3.8.13-alpine as base

WORKDIR /var/opt

COPY ./aws /root/.aws

RUN apk add --no-cache docker \
    build-base \
    libpq-dev \
    && pip install wheel \
    && pip install --no-cache-dir awscli \
    && pip install --no-cache-dir aws-sam-cli \
    && rm -rf /var/cache/apk/*

RUN aws --version