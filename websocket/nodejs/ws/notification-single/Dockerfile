FROM node:14.18.1-alpine as debug

WORKDIR /work/

COPY ./src/package.json /work/package.json
RUN npm install
RUN npm install -g nodemon

COPY ./src/ /work/src/

ENTRYPOINT [ "nodemon","--inspect=0.0.0.0","./src/app.js" ]

# FROM node:12.4.0-alpine as prod
#
# WORKDIR /work/
# COPY ./publisher/package.json /work/package.json
# RUN npm install
# COPY ./publisher/ /work/
#
# CMD node .