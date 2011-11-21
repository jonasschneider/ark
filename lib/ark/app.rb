require "sinatra"

module Ark
  class App < Sinatra::Base
    def repo
      settings.repo || raise('No repository configured')
    end
    
    get '/' do
      repo.chains.map{|c|c.name}.join(", ")
    end
    
    get '/chains/:name' do
      @chain = repo.chains.detect{|c|c.name == params[:name]}
      "#{@chain.backups.count} backups"
    end
    
    get '/chains/:name/backups/:id' do
      @chain = repo.chains.detect{|c|c.name == params[:name]}
      @backup = @chain.backups.detect{|c|c.id == params[:id]}
      "#{@backup.files.join(", ")}"
    end
  end
end