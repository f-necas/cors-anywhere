ARG NODE_VERSION=22

# Utiliser l'image Node.js spécifiée par la variable d'argument
FROM node:$NODE_VERSION AS builder
ARG NPM_ARGS
ENV NPM_ARGS=${NPM_ARGS}

RUN groupadd -r nodejs -g 433 && \
    useradd -u 431 -r -g nodejs -s /sbin/nologin -c "Docker image user" nodejs

RUN mkdir /home/nodejs && \
    chown -R nodejs:nodejs /home/nodejs

USER nodejs

WORKDIR /home/nodejs

COPY --chown=nodejs:nodejs package*.json ./

RUN npm install --only=production

COPY --chown=nodejs:nodejs . .



FROM node:$NODE_VERSION

WORKDIR /home/nodejs

COPY --from=builder --chown=nodejs:nodejs /home/nodejs .

EXPOSE 8080

CMD ["npm", "start"]
