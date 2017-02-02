ERL_INCLUDE_PATH=$(shell erl -eval 'io:format("~s~n", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)

all: priv/graphql_parser.so priv/graphqlparser

priv/graphql_parser.so: c_src/graphqlparser_nif.c
	cc -undefined dynamic_lookup -dynamiclib -I$(ERL_INCLUDE_PATH) -I/usr/local/include/graphqlparser/ -L/usr/local/lib -lgraphqlparser c_src/graphqlparser_nif.c -o priv/graphql_parser.so

priv/graphqlparser: c_src/graphqlparser.c
	gcc c_src/graphqlparser.c -o priv/graphqlparser -I/usr/local/include/graphqlparser -L/usr/local/lib -lgraphqlparser