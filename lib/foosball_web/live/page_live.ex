defmodule FoosballWeb.PageLive do
  use FoosballWeb, :live_view

  require Logger

  alias Foosball.Commands, as: C

  def mount(_params, _session, socket) do
    match_id = Ecto.UUID.generate()

    if connected?(socket) do
      Phoenix.PubSub.subscribe(Foosball.PubSub, "match:#{match_id}")
    end

    {:ok, assign(socket, %{match_id: match_id, score: %{home: 0, away: 0}})}
  end

  def handle_info({:score_update, %{home_score: home, away_score: away}}, socket) do
    {:noreply, assign(socket, :score, %{home: home, away: away})}
  end

  @impl true
  def handle_event("score-" <> side, _, socket) do
    Logger.info("Score event for #{side}")

    :ok =
      Foosball.Commanded.Application.dispatch(%C.Score{
        match_id: socket.assigns.match_id,
        side: String.to_atom(side)
      })

    {:noreply, socket}
  end
end
