FROM node:22-alpine AS base

RUN mkdir /code
WORKDIR /code

ENV BCOIN_REPO=https://github.com/bcoin-org/bcoin.git

RUN apk upgrade --no-cache && \
    apk add --no-cache bash git

RUN git clone $BCOIN_REPO /code

FROM base AS build
RUN apk add --no-cache g++ gcc make python3
RUN npm install --omit=dev

FROM base
ENV PATH="${PATH}:/code/bin:/code/node_modules/.bin"
COPY --from=build /code /code/

# mainnet or testnet
#EXPOSE 8334 
EXPOSE 8333 8332 
#EXPOSE 18334 18333 18332

CMD "bcoin"

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "bcoin-cli info >/dev/null" ]

