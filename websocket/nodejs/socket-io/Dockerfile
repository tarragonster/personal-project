FROM public.ecr.aws/n8y8v7k1/node:14.16-alpine

RUN mkdir -p /home/node/app
WORKDIR /home/node/app

COPY . .

RUN npm install -g typescript
RUN npm install

EXPOSE 4000

CMD ["npm", "start"]
