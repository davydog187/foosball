defmodule Foosball.Commanded.Handler do
  use Commanded.Event.Handler, application: Foosball.Commanded.Application, name: __MODULE__

  require Logger

  def handle(%Foosball.Events.ScoreUpdated{} = e, metadata) do
    Logger.info("Score of #{e.match_id} updated to #{e.away_score} to #{e.home_score}")

    Phoenix.PubSub.broadcast(
      Foosball.PubSub,
      "match:#{e.match_id}",
      {:score_update, Map.from_struct(e)}
    )

    case e.home_score do
      2 -> {:error, :random_error}
      3 -> raise "raising error"
      _ -> :ok
    end
  end

  def error(error, event, context) do
    :skip
  end
end
