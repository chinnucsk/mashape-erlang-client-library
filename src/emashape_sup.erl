%%%----------------------------------------------------------------
%%% @author  Tristan Sloughter <tristan@mashape.com>
%%% @doc
%%% @end
%%% @copyright 2012 Tristan Sloughter
%%%----------------------------------------------------------------
-module(emashape_sup).
-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).
                       

%%%===================================================================
%%% API functions
%%%===================================================================

-spec start_link() -> {ok, pid()} | any().
start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

%% @private
-spec init(list()) -> {ok, {SupFlags::any(), [ChildSpec::any()]}} |
                       ignore | {error, Reason::any()}.
init([]) ->
    RestartStrategy = one_for_one,
    MaxRestarts = 3,
    MaxSecondsBetweenRestarts = 60,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = permanent,
    Shutdown = 2000,
    Type = worker,

    PublicKey = default(application:get_env(emashape, public_key), undefined),
    PrivateKey = default(application:get_env(emashape, private_key), undefined),

    AChild = {emashape, {emashape, start_link, [PublicKey, PrivateKey]},
              Restart, Shutdown, Type, [emashape]},

    {ok, {SupFlags, [AChild]}}.
%%%===================================================================
%%% Internal functions
%%%===================================================================

default(undefined, Y) ->
    {ok, Y};
default(X, _Y) ->
    X.

%%%====================================================================
%%% tests
%%%====================================================================
