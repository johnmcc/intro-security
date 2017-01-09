require './models/user'
require 'sinatra'
require 'sinatra/contrib/all'

get '/authenticate/:username/:password' do
  if User.authenticate(params[:username], params[:password])
    return "This is a valid user! Logging in..."
  else
    return "This isn't a valid user... :("
  end
end