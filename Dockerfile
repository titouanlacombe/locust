FROM python:3.11-slim

# Create user
RUN useradd -m -s /bin/bash app
WORKDIR /home/app

# Linux packages
RUN apt update && apt install --no-install-recommends -y \
	# Base utils
	bash curl \
	&& apt clean

# Install python app requirements
RUN python3 -m pip install --no-cache-dir pipenv
COPY Pipfile Pipfile.lock ./
RUN pipenv sync --system --clear --verbose

# App sources
COPY ./src ./src

# Entrypoint
RUN chown -R app:app /home/app
WORKDIR /home/app/src
USER app
ENTRYPOINT ["locust", "-f", ".", "--class-picker"]
