defmodule Foosball.Commanded.Router do
  use Commanded.Commands.Router

  middleware(OpentelemetryCommanded.Middleware)

  dispatch(Foosball.Commands.Score, to: Foosball.Commanded.Match, identity: :match_id)
  dispatch(Foosball.Commands.Error, to: Foosball.Commanded.Match, identity: :match_id)
end
