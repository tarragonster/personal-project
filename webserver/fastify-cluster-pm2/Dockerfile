FROM node:14.18.1-alpine as debug

WORKDIR /work/

COPY ./src/package.json /work/package.json
RUN npm install
RUN npm install pm2@latest -g

COPY ./src/ /work/src/

ENTRYPOINT [ "pm2","start", "--no-daemon","./src/app.js", "-i max" ]
#https://stackoverflow.com/questions/54115503/why-is-pm2-not-launching-my-node-process

# FROM node:12.4.0-alpine as prod
#
# WORKDIR /work/
# COPY ./src/package.json /work/package.json
# RUN npm install
# COPY ./src/ /work/
#
# CMD node .