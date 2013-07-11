defmodule Scarecrow.Representers.UserPresenter do
  use Scarecrow.Representer

  property :user
  property :name

  link :self do
    "/user/#{represented[:user]}"
  end
end
