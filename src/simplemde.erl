-module(simplemde).
-behaviour(supervisor).
-behaviour(application).
-export([init/1, start/2, stop/1, editor/1, vendors/1]).
-include_lib("nitro/include/nitro.hrl").

start(_,_) -> supervisor:start_link({local,simplemde }, simplemde,[]).
stop(_)    -> ok.
init([])   -> sup().
sup()      -> { ok, { { one_for_one, 5, 100 }, [] } }.

vendors(T)     -> vendors(T,"/static/simplemde/"). 
vendors(css,B) -> wf:render(#meta_link{href=B++"simplemde.min.css",rel="stylesheet"});
vendors(js,B)  -> wf:render(#script{src=B++"simplemde.min.js"}).

editor(Id) ->
  wf:f(
  "new SimpleMDE({"
    "element: document.getElementById('#~s'),"
    "spellChecker: false,"
    "autosave: {"
      "enabled: true,"
      "unique_id: \"#~s\","
    "},"
  "});",[Id,Id]).
  