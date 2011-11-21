require File.expand_path('../env/helper', File.dirname(__FILE__))

describe "Ark::Repo" do
  let(:path) { File.join(SANDBOX_DIR, 'repo') }
  
  before :each do
    FileUtils.mkdir(path)
  end
  
  let(:repo) { Ark::Repo.new(path) }
  
  describe "#chains" do
    describe "without chains" do
      it "is empty" do
        repo.chains.should == []
      end
    end
    
    describe "with a chain" do
      before :each do
        FileUtils.mkdir File.join(path, 'bup.0')
        FileUtils.mkdir File.join(path, 'bup.1')
      end
      
      it "sees the chain" do
        repo.chains.length.should == 1
        repo.chains.first.name.should == 'bup'
        repo.chains.first.count.should == 2
      end
    end
    
    describe "with other files and directories" do
      before :each do
        FileUtils.mkdir File.join(path, 'bup.0')
        FileUtils.mkdir File.join(path, 'bup.1')
        FileUtils.mkdir File.join(path, 'ohai')
        FileUtils.touch File.join(path, 'test.txt')
      end
      
      it "still sees only the chain" do
        repo.chains.length.should == 1
        repo.chains.first.name.should == 'bup'
        repo.chains.first.count.should == 2
      end
    end
  end
end