require "sinatra"
require "haml"

module Ark
  class App < Sinatra::Base
    def manager
      settings.manager || raise('No manager configured')
    end
    
    def repo
      manager.first_repo
    end
    
    set :root, File.expand_path('app', File.dirname(__FILE__))
    
    get '/chains' do
      @chains = repo.chains
      haml :index
    end
    
    get '/chains/:name' do
      @chain = repo.chains.detect{|c|c.name == params[:name]}
      halt 404, 'Chain not found' unless @chain
      haml :chain
    end
    
    get '/chains/:name/backups/:id' do
      @chain = repo.chains.detect{|c|c.name == params[:name]}
      @backup = @chain.backups.detect{|c|c.id == params[:id]}
      "#{@backup.files.join(", ")}"
    end
  end
end