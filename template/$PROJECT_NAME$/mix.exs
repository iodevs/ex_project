defmodule <%= @project_name_camel_case %>.MixProject do
  use Mix.Project

  def project do
    [
      app: :<%= @project_name %>,
<%= if @dialyzer == "base" do %>
      dialyzer: [
        plt_add_apps: [:mix],
        plt_add_deps: :transitive,
        ignore_warnings: "dialyzer.ignore-warnings",
        flags: [
          :unmatched_returns,
          :error_handling,
          :race_conditions,
          :no_opaque
        ]
      ],
<% end %>
<%= if @dialyzer == "semaphore" do %>
      dialyzer: dialyzer_base() |> dialyzer_ptl(System.get_env("SEMAPHORE_CACHE_DIR")),
<% end %>
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
<%= if @dialyzer do %>
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false}
<%end %>
    ]
  end

<%= if @dialyzer == "semaphore" do %>
  defp dialyzer_base() do
    [
      plt_add_apps: [:mix],
      plt_add_deps: :transitive,
      ignore_warnings: "dialyzer.ignore-warnings",
      flags: [
        :unmatched_returns,
        :error_handling,
        :race_conditions,
        :no_opaque
      ]
    ]
  end

  defp dialyzer_ptl(base, nil) do
    base
  end

  defp dialyzer_ptl(base, path) do
    base ++
      [
        plt_core_path: path,
        plt_file:
          Path.join(
            path,
            "dialyxir_erlang-#{otp_vsn()}_elixir-#{System.version()}_deps-dev.plt"
          )
      ]
  end

  defp otp_vsn() do
    major = :erlang.system_info(:otp_release) |> List.to_string()
    vsn_file = Path.join([:code.root_dir(), "releases", major, "OTP_VERSION"])

    try do
      {:ok, contents} = File.read(vsn_file)
      String.split(contents, "\n", trim: true)
    else
      [full] ->
        full

      _ ->
        major
    catch
      :error, _ ->
        major
    end
  end
<% end %>
end
