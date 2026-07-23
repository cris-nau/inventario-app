FROM node:20-alpine AS test
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm test

FROM node:20-alpine AS final
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY --from=test /app/server.js ./
COPY --from=test /app/db.js ./
COPY --from=test /app/public ./public
COPY --from=test /app/data ./data
EXPOSE 3000
CMD ["node", "server.js"]