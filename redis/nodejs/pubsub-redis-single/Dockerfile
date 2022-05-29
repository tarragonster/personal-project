FROM node:14.18.1-alpine as publisher-debug

WORKDIR /work/

COPY publisher/package.json /work/package.json
COPY publisher/.env /work/.env

RUN npm install
RUN npm install -g nodemon

COPY publisher/ /work/src/

ENTRYPOINT [ "nodemon","--inspect=0.0.0.0","./publisher/app.js" ]

FROM node:14.18.1-alpine as subscriber-debug

WORKDIR /work/

COPY subscriber/package.json /work/package.json
COPY subscriber/.env /work/.env

RUN npm install
RUN npm install -g nodemon

COPY subscriber/ /work/src/

ENTRYPOINT [ "nodemon","--inspect=0.0.0.0","./subscriber/app.js" ]

# FROM node:12.4.0-alpine as prod
#
# WORKDIR /work/
# COPY ./publisher/package.json /work/package.json
# RUN npm install
# COPY ./publisher/ /work/
#
# CMD node .