%%%%
% NIF Module wrapping libgraphqlparser.
% Do not use this module directly. Use GraphQL.Parser module instead.
%%%%

-module(graphql_parser_nif).

-export([parse/1]).
-on_load(init/0).

-define(APPNAME, graphql_parser_nif).
-define(LIBNAME, graphql_parser).

parse(_) ->
  not_loaded(?LINE).

init() ->
  SoName = case code:priv_dir(?APPNAME) of
    {error, bad_name} ->
      case filelib:is_dir(filename:join(["..", priv])) of
        true ->
          filename:join(["..", priv, ?LIBNAME]);
        _ ->
          filename:join([priv, ?LIBNAME])
      end;
    Dir ->
      filename:join(Dir, ?LIBNAME)
  end,
  erlang:load_nif(SoName, 0).

not_loaded(Line) ->
  exit({not_loaded, [{module, ?MODULE}, {line, Line}]}).