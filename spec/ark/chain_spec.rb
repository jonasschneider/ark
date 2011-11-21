require File.expand_path('../env/helper', File.dirname(__FILE__))

describe "Ark::Chain" do
  let(:data_dir) { File.join(SANDBOX_DIR, 'data') }
  let(:backup_root) { File.join(SANDBOX_DIR, 'backup') }
  
  before :each do
    FileUtils.mkdir(data_dir)
  end
  
  describe "with a broken folder structure" do
    it "raises when the directory timestamps are not in order" do
      FileUtils.mkdir(backup_root+'.0')
      sleep 1
      FileUtils.mkdir(backup_root+'.1')
      
      lambda {
        Ark::Chain.new backup_root
      }.should raise_error "Bogus directory structure - backup.1 is newer than backup.0"
    end
    
    it "raises when there are holes" do
      FileUtils.mkdir(backup_root+'.0')
      FileUtils.mkdir(backup_root+'.1')
      FileUtils.mkdir(backup_root+'.3')
      
      lambda {
        Ark::Chain.new backup_root
      }.should raise_error "Bogus directory structure - Hole found after backup.1"
    end
    
    it "does not raise on a chain without backups" do
      lambda {
        Ark::Chain.new backup_root
      }.should_not raise_error
    end
  end
  
  describe "with a correct folder structure" do
    let(:chain) { Ark::Chain.new backup_root }
    
    before :each do
      FileUtils.mkdir (backup_root+'.0')
    end
    
    it "recognizes repo_path and name" do
      chain.repo_path.should == SANDBOX_DIR
      chain.name.should == 'backup'
    end
    
    it "gets the repo" do
      Ark::Repo.should_receive(:new).with(SANDBOX_DIR)
      chain.repo
    end
    
    describe "containing two backup versions" do
      before :each do
        put_file File.join(data_dir, 'hello.txt'), 'ohai'
        put_file File.join(data_dir, 'data'), 'constant'
        Ark::Noah.new(data_dir: data_dir, backup_dir: (backup_root+'.2')).run!
        put_file File.join(data_dir, 'hello.txt'), 'changed'
        Ark::Noah.new(data_dir: data_dir, backup_dir: (backup_root+'.1')).run!
        Ark::Noah.new(data_dir: data_dir, backup_dir: (backup_root+'.0')).run!
      end
      
      describe "#first" do
        it "returns the latest backup" do
          chain.first.path.should == (backup_root+'.0')
        end
      end
      
      describe "#noah" do
        it "returns a Noah that reuses the latest version" do
          n = chain.noah
          n.backup_dir.should == (backup_root+'.0')
          n.cache_dir.should == (backup_root+'.1')
          n.shift.should == [(backup_root+'.0'), (backup_root+'.1'), (backup_root+'.2')]
        end
      end
    end
  end
end