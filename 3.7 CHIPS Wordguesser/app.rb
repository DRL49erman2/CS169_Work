require 'sinatra/base'

class MyApp < Sinatra::Base
  set :host_authorization, {
    permitted_hosts: ['.codio.io', 'localhost', '127.0.0.1']
  }

  get '/' do
    "<!DOCTYPE html><html><head></head><body><h1>Your Mother</h1></body></html>"
  end
end