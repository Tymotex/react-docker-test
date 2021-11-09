# Uses a multi-stage build. First run the React build, then copy the output to an alpine Apache server container
FROM node:latest AS build

WORKDIR /build

COPY package.json package.json
COPY package-lock.json package-lock.json

# This is similar to `npm install`, except it's meant to be used in CI, deployment and anywhere else where you want to ensure a clean install of dependencies.
# The project must have an existing package-lock.json
# It never writes to package.json like npm install would.
RUN npm ci

COPY public/ public
COPY src/ src

RUN npm rkun build

FROM httpd:alpine

WORKDIR /var/www/html

COPY --from=build /build/build/ .
