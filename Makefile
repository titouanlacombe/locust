default: build up

# Context
export APP = locust
# export ENV = $(shell [ -f ../ENV ] && cat ../ENV || echo pro)
export ENV = dev
export VER = $(shell [ -f ./VERSION ] && cat ./VERSION || echo unknown)
export TZ = $(shell [ -f ../TZ ] && cat ../TZ || echo Europe/Paris)

# Global vars
export SHORT_ENV = $(shell echo ${ENV} | cut -c1-3)

# Make vars
COMPOSE=docker-compose -p ${APP}-${SHORT_ENV} -f ./docker-compose.yml -f ./docker-compose.${SHORT_ENV}.yml
COMPOSE_TIMEOUT = 2

# Parse make arguments by ignoring the first argument (the target)
ARGUMENTS=$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

req_arg:
	@if [ -z "${ARGUMENTS}" ]; then \
		echo "Arguments required but none given"; \
		exit 1; \
	fi

# Debug info
$(info --- ${APP} ---)
# $(info $$ENV is [${ENV}])
# $(info $$VER is [${VER}])
# $(info $$SHORT_ENV is [${SHORT_ENV}])
# $(info $$COMPOSE is [${COMPOSE}])
# $(info $$ARGUMENTS is [${ARGUMENTS}])

# Utils targets
mkdata:
	mkdir -p ../data
	
clean:
	@echo Nothing to clean

# Compose shortcuts
build: mkdata
	${COMPOSE} build ${ARGUMENTS}

up: mkdata
	${COMPOSE} up -d -t ${COMPOSE_TIMEOUT} ${ARGUMENTS}

recreate: mkdata
	${COMPOSE} up -d -t ${COMPOSE_TIMEOUT} --force-recreate ${ARGUMENTS}

down:
	${COMPOSE} down -t ${COMPOSE_TIMEOUT} ${ARGUMENTS}

restart:
	${COMPOSE} restart -t ${COMPOSE_TIMEOUT} ${ARGUMENTS}

run: req_arg
	${COMPOSE} run --rm ${ARGUMENTS}

attach: req_arg
	${COMPOSE} exec ${ARGUMENTS} bash

attach-root: req_arg
	${COMPOSE} exec -u root ${ARGUMENTS} bash

logs:
	${COMPOSE} logs -f --tail 500 ${ARGUMENTS}

ps:
	${COMPOSE} ps

config:
	${COMPOSE} config

# Aliases for compatibility with other projects
_clean: clean
_build: req_arg build
_buildall: build
_up: req_arg up
_upall: up
_down: req_arg down
_downall: down
_restart: req_arg restart
_restartall: restart
_run: run
_bash: attach
_bash-root: attach-root
_logs: logs
_status: ps
_config: config
_recreate: req_arg recreate
_recreateall: recreate
