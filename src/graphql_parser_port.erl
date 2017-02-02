%%%%
% CLI Module wrapping libgraphqlparser.
% Do not use this module directly. Use graphql_parser module instead.
%%%%

-module(graphql_parser_port).
%% API
-export([parse/1]).

-define(APPNAME, graphql_parser).
-define(LIBNAME, graphqlparser).

parse(Q)->
  BinName = case code:priv_dir(?APPNAME) of
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

  Port = erlang:open_port({spawn_executable, BinName}, [{args, [Q]}, binary]),

  ParsedQ = run(Port, [], <<>>),

  erlang:port_close(Port),

  ParsedQ.


run(Port, Lines, OldLine) ->
  receive
    {Port, {data, Data}} ->
      case Data of
        {eol, Line} ->
          run(Port, [<<OldLine/binary,Line/binary>> | Lines], <<>>);
        {noeol, Line} ->
          run(Port, Lines, <<OldLine/binary,Line/binary>>);
        _ -> {ok, Data}
      end;
    {Port, {exit_status, 0}} ->
      {ok, Lines};
    {Port, {exit_status, Status}} ->
      {error, Status, Lines}
  after
    1000 ->
      {error, timeout}
  end.
