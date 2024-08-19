FROM node:lts as dependencies
WORKDIR /admin
COPY package.json ./
RUN yarn install

FROM node:lts as builder
WORKDIR /admin
COPY . .
COPY --from=dependencies /admin/node_modules ./node_modules
RUN yarn build

FROM node:lts as runner
WORKDIR /admin
ENV NODE_ENV production

COPY --from=builder /admin/public ./public
COPY --from=builder /admin/package.json ./package.json
COPY --from=builder /admin/.next ./.next
COPY --from=builder /admin/node_modules ./node_modules

EXPOSE 8080
CMD ["yarn", "start"]
