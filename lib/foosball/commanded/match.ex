defmodule Foosball.Commanded.Match do
  # Aggregate
  defstruct id: nil, home_score: 0, away_score: 0

  alias Foosball.Events, as: E
  alias Foosball.Commands, as: C

  require Logger

  def execute(%__MODULE__{id: nil}, c) do
    [%E.MatchCreated{match_id: c.match_id}, execute(%__MODULE__{id: c.match_id}, c)]
  end

  def execute(%__MODULE__{}, %C.Error{}) do
    {:error, :failed_to_execute}
  end

  def execute(%__MODULE__{} = match, %C.Score{side: side} = c) do
    case side do
      :home ->
        %E.ScoreUpdated{
          match_id: match.id,
          home_score: match.home_score + 1,
          away_score: match.away_score
        }

      :away ->
        %E.ScoreUpdated{
          match_id: match.id,
          home_score: match.home_score,
          away_score: match.away_score + 1
        }
    end
  end

  def apply(%__MODULE__{} = match, %E.MatchCreated{match_id: id}) do
    %{match | id: id}
  end

  def apply(%__MODULE__{} = match, %E.ScoreUpdated{home_score: home, away_score: away}) do
    %{match | home_score: home, away_score: away}
  end

  def apply(%__MODULE__{} = match, command) do
    Logger.warn("ignoring command on apply #{inspect(command)}")
    match
  end
end
