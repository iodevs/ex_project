defmodule <%= @project_name_camel_case %>.MixProject do
  use Mix.Project

  def project do
    [
      app: :<%= @project_name %>,
      version: "0.1.0",
      elixir: "~> <%= @elixir_version |> String.split(".") |> Enum.take(2) |> Enum.join(".") %>",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
<%= if @is_supervisor? do %>
      mod: { <%= @project_name_camel_case %>.Application, [] },         # Entry point module and parameters
<% end %>
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:ex_doc, "~> 0.21", only: :dev},
      {:credo, "~> 1.1", only: [:dev, :test]},
      {:excoveralls, "~> 0.11", only: :test},
    ]
  end
end
