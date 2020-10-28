defmodule Foosball.Commanded.Handler do
  use Commanded.Event.Handler, application: Foosball.Commanded.Application, name: __MODULE__

  require Logger

  def handle(%Foosball.Events.ScoreUpdated{} = e, _metadata) do
    Logger.info("Score of #{e.match_id} updated to #{e.away_score} to #{e.home_score}")

    Phoenix.PubSub.broadcast(
      Foosball.PubSub,
      "match:#{e.match_id}",
      {:score_update, Map.from_struct(e)}
    )
  end
end
