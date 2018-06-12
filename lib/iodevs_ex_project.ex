defmodule IodevsExProject do

  @moduledoc File.read!(Path.join([__DIR__, "../README.md"]))

  use MixTemplates,
    name:       :iodevs_ex_project,
    short_desc: "A iodevs elixir project template",
    source_dir: "../template",
    based_on: :project

end
