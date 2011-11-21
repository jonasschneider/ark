require File.expand_path('../env/helper', File.dirname(__FILE__))

describe "Ark::Task" do
  let(:repo_path) { File.join(SANDBOX_DIR, 'repo') }
  let(:repo) { Ark::Repo.new repo_path }
  
  before :each do
    FileUtils.mkdir repo_path
    FileUtils.mkdir File.join(repo_path, 'hellobup.0')
  end
  
  describe "#initialize" do
    it "loads name, source and destination repo" do
      t = Ark::Task.new('hellobup', source: '/home/jonas/hello', repo: repo)
      t.name.should == 'hellobup'
      t.source.should == '/home/jonas/hello'
      t.repo.should == repo
    end
  end
  
  describe "#chain" do
    it "returns the named chain of the repo" do
      t = Ark::Task.new('hellobup', source: '/home/jonas/hello', repo: repo)
      t.chain.path.should == "#{repo_path}/hellobup"
    end
  end
  
  describe "#noah" do
    it "returns a Noah that backs up" do
      t = Ark::Task.new('hellobup', source: Ark::Source.load('/home/jonas/hello'), repo: repo)
      
      n = t.noah
      n.backup_dir.should == (repo_path+'/hellobup.0')
      n.cache_dir.should == (repo_path+'/hellobup.1')
      n.data_dir.should == '/home/jonas/hello'
    end
  end
end