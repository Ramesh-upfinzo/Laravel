# ---- Base stage ----
FROM node:22-alpine AS base
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# ---- Production stage ----
FROM node:22-alpine
WORKDIR /app

COPY --from=base /app /app

ENV NODE_ENV=production \
    PORT=5000

EXPOSE 5000

CMD ["npm", "run", "server"]

