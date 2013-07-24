defmodule UserPresenter do
  use Scarecrow.Presenter

  property :id
  property :user
  property :name

  link :self do
    "/user/#{represented[:id]}"
  end
end
