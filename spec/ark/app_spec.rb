require File.expand_path('../env/helper', File.dirname(__FILE__))

describe "Ark::App" do
  describe "when configured" do
    let(:repo_path) { File.join(SANDBOX_DIR, 'repo') }
    
    before :each do
      FileUtils.mkdir repo_path
      Ark::App.set :repo, Ark::Repo.new(repo_path)
    end
    
    it "displays a list of chains" do
      FileUtils.mkdir File.join(repo_path, 'bupchain.0')
      
      get '/'
      
      last_response.body.should include('bupchain')
    end
    
    it "displays a list of backups for a chain" do
      FileUtils.mkdir File.join(repo_path, 'bupchain.0')
      aFile = File.new(File.join(repo_path, 'bupchain.0/test.txt'), "w")
      aFile.write('new')
      aFile.close
      
      FileUtils.mkdir File.join(repo_path, 'bupchain.1')
      aFile = File.new(File.join(repo_path, 'bupchain.1/test.txt'), "w")
      aFile.write('old')
      aFile.close
      
      get '/chains/bupchain'
      
      last_response.body.should include('2 backups')
      last_response.body.should include('test.txt')
    end
  end
end