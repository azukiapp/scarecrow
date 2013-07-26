defmodule UserPresenter do
  use Scarecrow.Presenter

  property :id
  property :api_key
  property :confirmed
  property :created_at
  property :email
  property :is_super_user
  property :last_login
  property :name
  property :user
  property :password_encrypted
  property :verified
  property :verified_at

  link :self do
    "/user/#{represented[:api_key]}"
  end
end
