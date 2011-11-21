require File.expand_path('../env/helper', File.dirname(__FILE__))

describe "Ark::App" do
  describe "when configured" do
    let(:repo_path) { File.join(SANDBOX_DIR, 'repo') }
    let(:data_path) { File.join(SANDBOX_DIR, 'data') }
    let(:metadata_path) { File.join(SANDBOX_DIR, 'metadata.yml') }
    
    let(:metadata) { {repos: { mine: repo_path }, tasks: { bup: { source: data_path, repo: :mine }} } }
    let(:manager) { Ark::Manager.new(metadata) }
    let(:repo) { manager.first_repo }
    
    before :each do
      FileUtils.mkdir repo_path
      FileUtils.mkdir data_path
      FileUtils.mkdir File.join(repo_path, 'bup.0')
      FileUtils.mkdir File.join(repo_path, 'bup.1')
      put_file File.join(data_path, 'data.txt'), 'ohai'
      put_file metadata_path, YAML.dump(metadata)
      
      Ark::Cli.run metadata_path, silent: true
      
      Ark::App.set :manager, manager
    end
    
    it "displays a list of tasks" do
      get '/'
      
      last_response.body.should have_selector("a[href='/tasks/bup']")
    end
    
    it "displays a list of chains" do
      get '/chains'
      
      last_response.body.should have_selector("a[href='/chains/bup']")
    end
    
    it "displays a list of backups for a task" do
      get '/tasks/bup'
      
      last_response.body.should have_selector("a[href='/tasks/bup/backups/#{repo.chains.first.backups.first.id}']")
    end
    
    it "errors for a nonexistent chain" do
      get '/chains/lolz'
      
      last_response.status.should == 404
    end
    
    it "displays a list of files for a backup" do
      put_file File.join(repo_path, 'bup.0/test.txt'), 'new'
      put_file File.join(repo_path, 'bup.1/test.txt'), 'old'
      
      get "/chains/bup/backups/#{repo.chains.first.backups.first.id}"
      
      last_response.body.should include('test.txt')
    end
  end
end