require "sinatra"
require "haml"
require "ark/app/helpers"

module Ark
  class App < Sinatra::Base
    helpers Ark::AppHelpers
    
    def manager
      settings.manager || raise('No manager configured')
    end
    
    def repo
      manager.first_repo
    end
    
    set :root, File.expand_path('app', File.dirname(__FILE__))
    
    get '/' do
      @tasks = manager.tasks
      haml :index
    end
    
    get '/tasks/:name' do
      @task = manager.tasks.detect{|c| c.name.to_s == params[:name]}
      halt 404, 'Task not found' unless @task
      haml :task
    end
    
    
    get '/chains' do
      @chains = repo.chains
      haml :chains
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