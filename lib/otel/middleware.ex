defmodule OpentelemetryCommanded.Middleware do
  @behaviour Commanded.Middleware

  alias Commanded.Middleware.Pipeline
  import Pipeline

  require OpenTelemetry.Tracer

  def before_dispatch(%Pipeline{command: command} = pipeline) do
    # serialize trace parent
    trace_ctx =
      []
      |> :ot_propagation.http_inject()
      |> Enum.map(&Tuple.to_list/1)

    assign_metadata(pipeline, :trace_ctx, trace_ctx)
  end

  def after_dispatch(%Pipeline{command: command} = pipeline) do
    pipeline
  end

  def after_failure(%Pipeline{command: command} = pipeline) do
    pipeline
  end

  defp encode_ctx(:undefined), do: :undefined
  defp encode_ctx(ctx), do: Tuple.to_list()
end
