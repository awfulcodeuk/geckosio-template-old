FROM node:lts-gallium

RUN curl -sL https://unpkg.com/@pnpm/self-installer | node

# use node user instead of root
WORKDIR /app
RUN chown node:node ./
USER node

# copy both 'package.json' and 'package-lock.json' (if available)
COPY package*.json ./

# copy pnpm-lock.yaml
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