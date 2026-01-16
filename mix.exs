defmodule Membrane.H264.Nvenc.Plugin.MixProject do
  use Mix.Project

  @version "0.1.0"
  @github_url "https://github.com/cunningryan/membrane_h264_nvenc_plugin"

  def project do
    [
      app: :membrane_h264_nvenc_plugin,
      compilers: [:unifex, :bundlex] ++ Mix.compilers(),
      version: @version,
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: dialyzer(),

      # Hex
      description: "Membrane H264 encoder with NVENC support (falls back to x264)",
      package: package(),

      # Docs
      name: "Membrane H264 NVENC plugin",
      source_url: @github_url,
      homepage_url: "https://membraneframework.org",
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: []
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]

  defp deps do
    [
      {:bunch, "~> 1.6"},
      {:bundlex, "~> 1.5"},
      {:unifex, "~> 1.2"},
      {:membrane_precompiled_dependency_provider, "~> 0.1.0"},
      {:membrane_core, "~> 1.0"},
      {:membrane_common_c, "~> 0.16.0"},
      {:membrane_h264_format, "~> 0.6.1"},
      {:membrane_raw_video_format, "~> 0.3.0"},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: :dev, runtime: false},
      # Test deps temporarily removed to avoid transitive dependency conflicts
      # {:membrane_raw_video_parser_plugin, "~> 0.11.2", only: :test},
      # {:membrane_file_plugin, "~> 0.17.0", only: :test},
      # {:membrane_h26x_plugin, "~> 0.10.0", only: :test}
    ]
  end

  defp dialyzer() do
    opts = [
      flags: [:error_handling]
    ]

    if System.get_env("CI") == "true" do
      # Store PLTs in cacheable directory for CI
      File.mkdir_p!(Path.join([__DIR__, "priv", "plts"]))
      [plt_local_path: "priv/plts", plt_core_path: "priv/plts"] ++ opts
    else
      opts
    end
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      formatters: ["html"],
      source_ref: "v#{@version}",
      nest_modules_by_prefix: [
        Membrane.H264.Nvenc
      ]
    ]
  end

  defp package do
    [
      maintainers: ["Membrane Team"],
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @github_url,
        "Membrane Framework Homepage" => "https://membraneframework.org"
      },
      files: ["lib", "mix.exs", "README*", "LICENSE*", ".formatter.exs", "bundlex.exs", "c_src"],
      exclude_patterns: [~r"c_src/.*/_generated.*"]
    ]
  end
end
