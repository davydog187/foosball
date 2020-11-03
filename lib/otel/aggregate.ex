defmodule OpentelemetryCommanded.Aggregate do
  require OpenTelemetry.Span
  require OpenTelemetry.Tracer

  alias OpenTelemetry.Span
  alias OpenTelemetry.Tracer

  def setup do
    :telemetry.attach(
      {__MODULE__, :start},
      [:commanded, :aggregate, :execute, :start],
      &__MODULE__.handle_start/4,
      []
    )

    :telemetry.attach(
      {__MODULE__, :stop},
      [:commanded, :aggregate, :execute, :stop],
      &__MODULE__.handle_stop/4,
      []
    )
  end

  def handle_start(event, measurements, meta, _) do
    IO.inspect(meta, label: "aggregate meta")
    ctx = Enum.map(meta.execution_context.metadata.trace_ctx, &List.to_tuple/1)

    _ = :ot_propagation.http_extract(ctx)

    Tracer.start_span("commanded:aggregate:execute", %{kind: :CONSUMER})
  end

  def handle_stop(event, measurements, meta, _) do
    Tracer.end_span()
  end
end
