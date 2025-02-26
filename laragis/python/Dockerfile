# syntax=docker/dockerfile:1  # Enable Docker BuildKit features
# Keep this syntax directive! It's used to enable Docker BuildKit

########################################################
# BASE
# Sets up all our shared environment variables
########################################################
ARG BASE_IMAGE=python:3.11.8-slim
FROM ${BASE_IMAGE}

LABEL maintainer="Truong Thanh Tung <ttungbmt@gmail.com>"

# Set timezone and Poetry version
ARG TZ=UTC
ARG POETRY_VERSION=2.1.1

# Define the application directory
ARG APP_PATH=/app
ENV APP_PATH=${APP_PATH}

# Set Environment Variables
ENV DEBIAN_FRONTEND=noninteractive

# Configure timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add a non-root user to prevent files being created with root permissions on host machine.
ARG PU=laragis
ARG PG=laragis
ARG PUID=1000
ENV PUID=${PUID}
ARG PGID=1000
ENV PGID=${PGID}

RUN getent passwd ${PUID} >/dev/null 2>&1 && userdel -r ${PU} || true && \
    getent group ${PGID} >/dev/null 2>&1 && groupdel ${PG} || true && \
    groupadd --force -g ${PGID} ${PG} && \
    useradd -u ${PUID} -g ${PG} -s /bin/bash -m ${PU}

# Install system tools and libraries.
# Utilize --mount flag of Docker Buildx to cache downloaded packages, avoiding repeated downloads
RUN --mount=type=cache,id=apt-build,target=/var/cache/apt \
    apt-get update && \ 
    apt-get install -y --no-install-recommends \
        curl \
        gettext

# Cleanup apt update lists to keep the image size small
RUN apt-get autoremove --purge &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set environment variables for Python and Poetry
ENV \
    # Python -----------------------------------
    # Ensures Python output is sent directly to the terminal
    PYTHONUNBUFFERED=1 \
    # Prevents python creating .pyc files
    PYTHONDONTWRITEBYTECODE=1 \
    \
    # pip --------------------------------------
    # Disables unnecessary version check for pip    
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    # Sets a timeout for pip operations to prevent hangs
    PIP_DEFAULT_TIMEOUT=100 \
    \
    # Poetry -----------------------------------
    # Specifies the Poetry version to use
    POETRY_VERSION=$POETRY_VERSION \
    # Specifies the directory where Poetry is installed
    POETRY_HOME="/opt/poetry" \
    # Disables interactive prompts during Poetry installation
    POETRY_NO_INTERACTION=1 \
    # Instructs Poetry not to create virtual environments (since the container itself acts as an isolated environment)
    POETRY_VIRTUALENVS_CREATE=false \
    # Path to the virtual environment (created by Poetry)
    VIRTUAL_ENV="/venv"

# Prepend poetry and venv to path
ENV PATH="$POETRY_HOME/bin:$VIRTUAL_ENV/bin:$PATH"

# Create and prepare the virtual environment
RUN python -m venv $VIRTUAL_ENV && \
    python -m pip install --upgrade pip

# Install poetry - respects $POETRY_VERSION & $POETRY_HOME
# The --mount will mount the buildx cache directory to where
# Poetry and Pip store their cache so that they can re-use it
RUN --mount=type=cache,target=/root/.cache \
    curl -sSL https://install.python-poetry.org | python3 -

# Set the working directory inside the container
RUN mkdir -p ${APP_PATH} 
WORKDIR ${APP_PATH}
