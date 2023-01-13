# the basic container
FROM node:alpine3.10

# who maintains this huge docker image
LABEL maintainer "nbenaglia@somedomain.com"

# the project source content
COPY public /public/
COPY src /src/
COPY package*.json ./

# let's install all the stuff
RUN npm install --ignore-scripts --production

# what port is exposed
EXPOSE 3000

# for a safer running container
USER 1000

ENTRYPOINT ["npm", "start"]