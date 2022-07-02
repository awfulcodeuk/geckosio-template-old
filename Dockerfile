FROM alpine

RUN apk --no-cache add curl

RUN apk add --update nodejs npm

RUN curl -sL https://unpkg.com/@pnpm/self-installer | node

RUN apk add --update python3 py3-pip

# use node user instead of root
WORKDIR /app

# copy 'package.json'
COPY package.json ./

# copy 'pnpm-lock.yaml'
COPY pnpm-lock.yaml ./

# install project dependencies
RUN pnpm install

COPY . .

RUN npm run build

# set environment to be production
ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

RUN ls -al /app

EXPOSE 3002 9209 28000-28100/udp
CMD [ "node", "server/server.js" ]