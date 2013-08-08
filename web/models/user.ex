defmodule User do
  use Scarecrow.Models.Document
  use Scarecrow.Models.Timestamps

  field :id
  field :name
  field :username
  field :email
  field :password
  field :verified, default: false
  field :verified_at, default: nil

  field :api_key, default: fn self(api_key: api_key) ->
    api_key || Scarecrow.Utils.api_key
  end

  def any, do: nil
end
