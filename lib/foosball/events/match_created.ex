defmodule Foosball.Events.MatchCreated do
  @derive Jason.Encoder
  defstruct [:match_id]
end
