FROM nodejs-builder as rosetta-server-builder-dev
RUN mkdir /app
COPY package.json yarn.lock .yarnrc tsconfig-dist.json tsconfig.json /app/
COPY packages-cache /app/packages-cache
WORKDIR /app
RUN yarn --offline --frozen-lockfile --non-interactive
COPY src /app/src
RUN yarn build

FROM nodejs-builder as rosetta-server-production-deps-dev
RUN mkdir -p /app/src
COPY --from=rosetta-server-builder-dev /app/packages-cache /app/packages-cache
COPY --from=rosetta-server-builder-dev /app/.yarnrc /app/yarn.lock /app/package.json /app/
WORKDIR /app
RUN yarn --offline --frozen-lockfile --non-interactive --production

FROM ubuntu-nodejs as cardano-rosetta-server
COPY --from=rosetta-server-builder-dev /app/dist /cardano-rosetta-server/dist
COPY --from=rosetta-server-production-deps-dev /app/node_modules /cardano-rosetta-server/node_modules
COPY config/network /config/network
EXPOSE 8080
CMD ["node", "/cardano-rosetta-server/dist/src/server/index.js"]

FROM runtime-base
ARG CARDANO_NETWORK=mainnet
COPY --from=rosetta-server-builder-dev /app/dist /cardano-rosetta-server/dist
COPY --from=rosetta-server-production-deps-dev /app/node_modules /cardano-rosetta-server/node_modules
COPY config/ecosystem.config.js .
COPY config/postgres/postgresql.conf /etc/postgresql/12/main/postgresql.conf
COPY config/network/${CARDANO_NETWORK} /config/
COPY scripts/entrypoint.sh .
