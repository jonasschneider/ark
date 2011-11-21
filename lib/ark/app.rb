require "sinatra"
require "haml"

module Ark
  class App < Sinatra::Base
    def repo
      settings.repo || raise('No repository configured')
    end
    
    set :root, File.expand_path('app', File.dirname(__FILE__))
    
    get '/' do
      @chains = repo.chains
      haml :index
    end
    
    get '/chains/:name' do
      @chain = repo.chains.detect{|c|c.name == params[:name]}
      haml :chain
    end
    
    get '/chains/:name/backups/:id' do
      @chain = repo.chains.detect{|c|c.name == params[:name]}
      @backup = @chain.backups.detect{|c|c.id == params[:id]}
      "#{@backup.files.join(", ")}"
    end
  end
end