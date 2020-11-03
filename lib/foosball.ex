defmodule Foosball do
  @moduledoc """
  Foosball keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  require OpenTelemetry.Tracer
  require OpenTelemetry.Span

  def dispatch(%name{} = command) do
    attr = [command_name: name]

    OpenTelemetry.Tracer.with_span "command:dispatch", %{attributes: attr} do
      Foosball.Commanded.Application.dispatch(command)
    end
  end
end
