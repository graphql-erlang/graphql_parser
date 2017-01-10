-module(graphql_parser).
-author("mrchex").

%% API
-export([
  parse/1
]).


-spec parse(binary()) -> map().
parse(RawGraphqlQuery)->
  case graphql_parser_nif:parse(RawGraphqlQuery) of
    {ok, Json} -> {ok, jsx:decode(Json, [return_maps])};
    {error, Error}-> {error, Error}
  end.