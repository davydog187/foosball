defmodule Foosball.Commanded.Router do
  use Commanded.Commands.Router

  dispatch(Foosball.Commands.Score, to: Foosball.Commanded.Match, identity: :match_id)
end
