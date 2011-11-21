require File.expand_path('../env/helper', File.dirname(__FILE__))

describe "Ark::Repo" do
  let(:root) { File.join(SANDBOX_DIR, 'repo') }
  
  before :each do
    FileUtils.mkdir(root)
  end
  
  let(:repo) { Ark::Repo.new(root) }
  
  describe "#chains" do
    describe "without chains" do
      it "is empty" do
        repo.chains.should == []
      end
    end
    
    describe "with a chain" do
      before :each do
        FileUtils.mkdir File.join(root, 'bup.0')
        FileUtils.mkdir File.join(root, 'bup.1')
      end
      
      it "sees the chain" do
        repo.chains.length.should == 1
        repo.chains.first.name.should == 'bup'
        repo.chains.first.count.should == 2
      end
    end
    
    describe "with other files and directories" do
      before :each do
        FileUtils.mkdir File.join(root, 'bup.0')
        FileUtils.mkdir File.join(root, 'bup.1')
        FileUtils.mkdir File.join(root, 'ohai')
        FileUtils.touch File.join(root, 'test.txt')
      end
      
      it "still sees only the chain" do
        repo.chains.length.should == 1
        repo.chains.first.name.should == 'bup'
        repo.chains.first.count.should == 2
      end
    end
  end
end