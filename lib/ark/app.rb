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
      chain = repo.chains.detect{|c|c.name == params[:name]}
      "#{chain.first.files.join(", ")}"+  "#{chain.count} backups"
    end
  end
end