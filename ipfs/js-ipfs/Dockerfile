FROM node:17.2.0-alpine as debug

WORKDIR /work/

COPY ./src/package.json /work/package.json
RUN npm install
RUN npm install -g nodemon

COPY ./src/ /work/src/

# FROM node:12.4.0-alpine as prod
#
# WORKDIR /work/
# COPY ./src/package.json /work/package.json
# RUN npm install
# COPY ./src/ /work/
#
# CMD node .