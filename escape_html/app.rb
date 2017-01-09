require './models/user'
require 'sanitize'
require 'sinatra'
require 'sinatra/contrib/all'

get '/users/:id' do
  @user = User.get(params[:id])
  erb(:index)
end