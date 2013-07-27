defmodule Scarecrow.Models.Timestamps do
  defmacro __using__(_opts) do
    quote do
      field :created_at
      field :updated_at

      @after_new { unquote(__MODULE__), :set_timestamps }
    end
  end

  def set_timestamps(record) do
    record.update(
      created_at: Date.now,
      updated_at: Date.now
    )
  end
end
