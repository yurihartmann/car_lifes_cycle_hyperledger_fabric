FROM node:16-alpine3.14

WORKDIR /app
ENV NODE_ENV production

COPY --chown=node:node . /app

RUN npm install

EXPOSE 3000  

USER node

ENTRYPOINT [ "npm", "run"]
CMD ["start"]
