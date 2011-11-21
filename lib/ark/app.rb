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
    
    def load_task!
      @task = manager.tasks.detect{|c| c.name.to_s == params[:name]}
      halt 404, 'Task not found' unless @task
    end
    
    set :root, File.expand_path('app', File.dirname(__FILE__))
    
    get '/' do
      @tasks = manager.tasks
      haml :index
    end
    
    get '/tasks/:name' do
      load_task!
      haml :task
    end
    
    get '/tasks/:name/backups/:id' do
      load_task!
      @backup = @task.chain.backups.detect{|c|c.id == params[:id]}
      haml :backup
    end
  end
end