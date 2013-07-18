defmodule Scarecrow.Config do
  use Docker.ConfigBase, Scarecrow.Mixfile.project[:app]
end
