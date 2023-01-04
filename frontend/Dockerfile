FROM node:14-alpine AS build

WORKDIR /usr/src/app
ADD package.json .
RUN npm install

FROM node:14-alpine
COPY --from=build /usr/src/app/ .
ADD . .
EXPOSE 3000
CMD ["npm", "start"]