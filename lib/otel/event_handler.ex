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

  def handle_start(_event, measurements, %{recorded_event: event, handler_state: handler}, _) do
    ctx = Enum.map(event.metadata["trace_ctx"], &List.to_tuple/1)

    _ = :ot_propagation.http_extract(ctx)

    attributes = [
      "causation.id": event.causation_id,
      "correlation.id": event.correlation_id,
      "event.id": event.event_id,
      "event.number": event.event_number,
      "event.type": event.event_type,
      "stream.id": event.stream_id,
      "stream.version": event.stream_version,
      application: handler.application,
      consistency: handler.consistency,
      "handler.module": handler.handler_module,
      "handler.name": handler.handler_name,
      "event.last_seen": handler.last_seen_event
    ]

    Tracer.start_span("commanded:event:handle", %{kind: :CONSUMER, attributes: attributes})
  end

  def handle_stop(event, measurements, meta, _) do
    Tracer.end_span()
  end
end
