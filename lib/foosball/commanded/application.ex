defmodule Foosball.Commanded.Application do
  use Commanded.Application,
    otp_app: :foosball,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: Foosball.EventStore
    ]

  router(Foosball.Commanded.Router)
end
