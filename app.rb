require 'pry'
require 'sinatra'

require 'better_errors'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

# this will store your users
users = []

# this will store an id to user for your users
# you'll need to increment it every time you add
# a new user, but don't decrement it
id = 1

# routes to implement:
#
# GET / - show all users
get '/' do
  @users = users
  erb :index
end

# GET /users/new - display a form for making a new user
get '/users/new' do
  erb :new_user
end
# POST /users - create a user based on params from form
post '/users' do 
  users.push({name: "#{params[:first]} #{params[:last]}", id: id})
  id += 1
  redirect '/'
end
# GET /users/:id - show a user's info by their id, this should display the info in a form
get '/users/:id' do
  @users = users
  @current_user = @users.detect {|i| i[:id] === params[:id].to_i}
  erb :edit_user

end
# PUT /users/:id - update a user's info based on the form from GET /users/:id
put '/users/:id' do
  @current_user = users[params[:id].to_i - 1]
  @current_user[:name] = params[:name]
  redirect '/'
end
# DELETE /users/:id - delete a user by their id
delete '/users/:id' do
  @current_user = users.detect {|i| i[:id] == params[:id].to_i}
  @current_user.delete_if {|key, value| value == params[:id].to_i}
  redirect '/'

end