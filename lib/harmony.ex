defmodule Harmony do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Harmony.Router, [], [
        port: port(),
        dispatch: dispatch()
      ])
    ]

    opts = [strategy: :one_for_one, name: Harmony.Supervisor]

    Supervisor.start_link(children, opts)
  end

  defp port do
    System.get_env("PORT") || 4000
  end

  defp dispatch do
    [
      {:_, [
        {"/chat", Harmony.SocketHandler, []},
        {:_, Plug.Adapters.Cowboy.Handler, {Harmony.Router, []}}
      ]}
    ]
  end
end
