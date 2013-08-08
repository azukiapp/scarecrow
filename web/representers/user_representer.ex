defmodule UserRepresenter do
  use Scarecrow.Representer

  property :id
  property :api_key
  property :confirmed
  #property :created_at
  property :email
  property :is_super_user
  property :last_login
  property :name
  property :username
  property :password_encrypted
  property :verified
  property :verified_at

  link :self do
    "/user/#{represented[:api_key]}"
  end
end
