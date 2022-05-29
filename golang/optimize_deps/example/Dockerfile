ARG DEPS_IMAGE_TAG

FROM aqaurius6666/node-test:${DEPS_IMAGE_TAG} as deps

FROM node:16.13-alpine as runner

WORKDIR /app

COPY --from=deps /app/node_modules node_modules

COPY . .

CMD ["node", "index.js"]