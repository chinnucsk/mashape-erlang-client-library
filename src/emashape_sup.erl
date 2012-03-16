%%%----------------------------------------------------------------
%%% @author  Tristan Sloughter <tristan@mashape.com>
%%% @doc
%%% @end
%%% @copyright 2012 Tristan Sloughter
%%%----------------------------------------------------------------
-module(emashape_sup).
-behaviour(supervisor).

%% API
-export([start_link/0,
         create/3]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

-spec start_link() -> {ok, pid()} | any().
start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

create(Name, PublicKey, PrivateKey) ->
    supervisor:start_child(?SERVER, [Name, PublicKey, PrivateKey]).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

%% @private
-spec init(list()) -> {ok, {SupFlags::any(), [ChildSpec::any()]}} |
                       ignore | {error, Reason::any()}.
init([]) ->
    RestartStrategy = simple_one_for_one,
    MaxRestarts = 0,
    MaxSecondsBetweenRestarts = 1,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = temporary,
    Shutdown = 2000,
    Type = worker,

    AChild = {emashape, {emashape, start_link, []},
              Restart, Shutdown, Type, [emashape]},

    {ok, {SupFlags, [AChild]}}.
%%%===================================================================
%%% Internal functions
%%%===================================================================

%%%====================================================================
%%% tests
%%%====================================================================
