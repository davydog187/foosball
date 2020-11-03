defmodule OpentelemetryCommanded.EventHandler do
  require OpenTelemetry.Tracer

  alias OpenTelemetry.Span
  alias OpenTelemetry.Tracer

  def setup do
    :telemetry.attach(
      {__MODULE__, :start},
      [:commanded, :event, :handle, :start],
      &__MODULE__.handle_start/4,
      []
    )

    :telemetry.attach(
      {__MODULE__, :stop},
      [:commanded, :event, :handle, :stop],
      &__MODULE__.handle_stop/4,
      []
    )
  end

  # recorded_event: %Commanded.EventStore.RecordedEvent{
  #   causation_id: "d01d6b3c-8e36-46a8-b63d-8fc59ccfb86b",
  #   correlation_id: "1a649c16-5879-4736-b32a-d4d78964c4ab",
  #   created_at: ~U[2020-11-03 15:13:40.230474Z],
  #   data: %Foosball.Events.MatchCreated{
  #     match_id: "4f91789d-5bcb-404b-b763-968405a7addc"
  #   },
  #   event_id: "8a36e9ad-dee9-427f-97fc-cf0dc85fb1c1",
  #   event_number: 371,
  #   event_type: "Elixir.Foosball.Events.MatchCreated",
  #   metadata: %{
  #     "trace_ctx" => [
  #       ["traceparent",
  #        "00-13d93a0bb9f6b774a28913127a36beca-cb255df1a3a8ba8d-01"]
  #     ]
  #   },
  #   stream_id: "4f91789d-5bcb-404b-b763-968405a7addc",
  #   stream_version: 1
  # }
  def handle_start(_event, measurements, %{recorded_event: event} = meta, _) do
    IO.inspect(meta, label: "event handler meta")
    ctx = Enum.map(event.metadata["trace_ctx"], &List.to_tuple/1)

    _ = :ot_propagation.http_extract(ctx)

    attributes = [
      "causation.id": event.causation_id,
      "correlation.id": event.correlation_id,
      "event.id": event.event_id,
      "event.number": event.event_number,
      "event.type": event.event_type,
      "stream.id": event.stream_id,
      "stream.version": event.stream_version
    ]

    Tracer.start_span("commanded:event:handle", %{kind: :CONSUMER, attributes: attributes})
  end

  def handle_stop(event, measurements, meta, _) do
    Tracer.end_span()
  end
end
