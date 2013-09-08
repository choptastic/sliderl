all: get-deps plugins copy-static compile

submodules:
	git submodule init
	git submodule update

get-deps:
	./rebar get-deps

compile:
	./rebar compile

plugins:
	@(export PATH=`pwd`/`echo erts-*/bin`:$$PATH;escript do-plugins.escript)

copy-static:
	@(cp -r deps/nitrogen_core/www/* priv/static//nitrogen/)

run:
	erl \
		-name sliderl@127.0.0.1 \
		-env ERL_LIBS ./deps/ \
		-sync sync_mode nitrogen \
		-env ERL_FULLSWEET_AFTER 0 \
		-config "etc/app.config" \
		-config "etc/inets.config" \
		-pa ebin/ \
		-eval "application:start(inets)" \
		-eval "application:start(sliderl)"
