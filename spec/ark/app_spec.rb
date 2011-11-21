require File.expand_path('../env/helper', File.dirname(__FILE__))

describe "Ark::App" do
  describe "when configured" do
    let(:repo_path) { File.join(SANDBOX_DIR, 'repo') }
    let(:repo) { Ark::Repo.new(repo_path) }
    
    before :each do
      FileUtils.mkdir repo_path
      Ark::App.set :repo, repo
    end
    
    it "displays a list of chains" do
      FileUtils.mkdir File.join(repo_path, 'bupchain.0')
      
      get '/'
      
      last_response.body.should have_selector("a[href='/chains/bupchain']")
    end
    
    it "displays a list of backups for a chain" do
      FileUtils.mkdir File.join(repo_path, 'bupchain.0')
      FileUtils.mkdir File.join(repo_path, 'bupchain.1')
      
      get '/chains/bupchain'
      
      last_response.body.should have_selector("a[href='/chains/bupchain/backups/#{repo.chains.first.backups.first.id}']")
    end
    
    it "displays a list of files for a backup" do
      FileUtils.mkdir File.join(repo_path, 'bupchain.0')
      put_file File.join(repo_path, 'bupchain.0/test.txt'), 'new'
      
      FileUtils.mkdir File.join(repo_path, 'bupchain.1')
      put_file File.join(repo_path, 'bupchain.1/test.txt'), 'old'
      
      get "/chains/bupchain/backups/#{repo.chains.first.backups.first.id}"
      
      last_response.body.should include('test.txt')
    end
  end
end