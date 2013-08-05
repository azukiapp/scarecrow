defmodule Scarecrow.Utils do
  def api_key do
    "#{:uuid.to_string(:uuid.uuid4())}"
  end
end
