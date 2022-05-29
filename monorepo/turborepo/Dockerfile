FROM node:14.18.1-alpine as debug

WORKDIR /work/

COPY . /work/

RUN yarn
RUN chmod +x entrypoint.sh

ENTRYPOINT ["sh", "./entrypoint.sh"]

# FROM node:12.4.0-alpine as prod
#
# WORKDIR /work/
# COPY ./src/package.json /work/package.json
# RUN npm install
# COPY ./src/ /work/
#
# CMD node .