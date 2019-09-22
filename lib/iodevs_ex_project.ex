defmodule IodevsExProject do

  @moduledoc File.read!(Path.join([__DIR__, "../README.md"]))

  use MixTemplates,
    name:       :iodevs_ex_project,
    short_desc: "A iodevs elixir project template",
    source_dir: "../template",
    based_on: :project,
    options: [
      dia: [
        to: :dialyzer,
        # default: nil,
        takes: "ci_platform",
        desc: "append dialyzer settings (default: nil). Posible values is base, semaphore."
      ],
      dialyzer: [same_as: :dia]
    ]

end
