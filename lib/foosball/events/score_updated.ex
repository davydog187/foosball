defmodule Foosball.Events.ScoreUpdated do
  @derive Jason.Encoder
  defstruct [:match_id, :home_score, :away_score]
end
