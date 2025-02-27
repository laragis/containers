########################################################
# BASE
# Sets up all our shared environment variables
########################################################
ARG BASE_IMAGE=ttungbmt/python:3.11-slim
FROM ${BASE_IMAGE} AS base

########################################################
# BUILDER
# Used to build deps + create our virtual environment
########################################################
FROM base AS builder

ARG POETRY_INSTALL_OPTS='--no-root --only main'
ARG SCRAPYD_VERSION=master

# Set the working directory inside the container
WORKDIR ${APP_PATH}

COPY README.md pyproject.toml poetry.lock ./

RUN --mount=type=cache,target=/root/.cache \
    poetry add \
        git+https://github.com/scrapy/scrapyd.git#$SCRAPYD_VERSION

# Install dependencies with Poetry, caching downloaded packages
RUN --mount=type=cache,target=/root/.cache \
    poetry install ${POETRY_INSTALL_OPTS}

########################################################
# RUNNER
########################################################
FROM base AS runner

ARG APP_PORT=6800
ENV APP_PORT=${APP_PORT}

ARG SCRAPYD_USERNAME=admin
ENV SCRAPYD_USERNAME=${SCRAPYD_USERNAME}

ARG SCRAPYD_PASSWORD=admin
ENV SCRAPYD_PASSWORD=${SCRAPYD_PASSWORD}

# Set the working directory inside the container
WORKDIR ${APP_PATH}

COPY ./scrapyd.conf.tpl /etc/scrapyd/scrapyd.conf.tpl

# Copying in our entrypoint
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=builder \
    ${APP_PATH}/README.md \
    ${APP_PATH}/poetry.lock \
    ${APP_PATH}/pyproject.toml \
    ./

# Copy in our built poetry + venv
COPY --from=builder $POETRY_HOME $POETRY_HOME
COPY --from=builder $VIRTUAL_ENV $VIRTUAL_ENV

RUN mkdir -p \
        /data/ \
        /etc/scrapyd/ \
        /var/lib/scrapyd/

VOLUME /etc/scrapyd/ /var/lib/scrapyd/

# Expose the port the app runs on
EXPOSE ${APP_PORT}

########################################################
# DEVELOPMENT
# Image used during development / testing
########################################################
FROM runner AS development

ENV APP_ENV=development

# Not installing the app itself in the venv to keep venv and app in separate paths
ARG POETRY_INSTALL_OPTS='--no-root'

# Set the working directory inside the container
WORKDIR ${APP_PATH}

# Quicker install as runtime deps are already installed
RUN --mount=type=cache,target=/root/.cache \
    poetry install ${POETRY_INSTALL_OPTS}

ENTRYPOINT ["/entrypoint.sh"]

CMD ["scrapyd", "--pidfile="]

########################################################
# PRODUCTION
# Final image used for runtime
########################################################
FROM runner AS production

ENV APP_ENV=production

# Set the working directory inside the container
WORKDIR ${APP_PATH}

RUN chown -R ${PUID}:${PGID} ./ /data /etc/scrapyd/ /var/lib/scrapyd/
    
# Switch to user
USER ${PUID}:${PGID}

ENTRYPOINT ["/entrypoint.sh"]

CMD ["scrapyd", "--pidfile="]