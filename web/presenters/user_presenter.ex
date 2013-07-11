defmodule UserPresenter do
  use Scarecrow.Presenter

  property :user
  property :name

  link :self do
    "/user/#{represented[:user]}"
  end
end
