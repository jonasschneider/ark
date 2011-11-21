require "sinatra"

module Ark
  class App < Sinatra::Base
    get '/' do
      'ohai'
    end
  end
end