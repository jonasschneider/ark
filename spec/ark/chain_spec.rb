require File.expand_path('../env/helper', File.dirname(__FILE__))

describe "Ark::Chain" do
  let(:data_dir) { File.join(SANDBOX_DIR, 'data') }
  let(:backup_root) { File.join(SANDBOX_DIR, 'backup') }
  
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
  end
  
  describe "with a correct folder structure" do
    let(:chain) { Ark::Chain.new backup_root }
    
    it "recognizes the prefix and name" do
      chain.prefix.should == SANDBOX_DIR
      chain.name.should == 'backup'
    end
    
    describe "containing two backup versions" do
      
      before :each do
        put_file 'data/hello.txt', 'ohai'
        put_file 'data/data', 'constant'
        Ark::Noah.new(data_dir: data_dir, backup_dir: (backup_root+'.2')).run!
        put_file 'data/hello.txt', 'changed'
        Ark::Noah.new(data_dir: data_dir, backup_dir: (backup_root+'.1')).run!
        Ark::Noah.new(data_dir: data_dir, backup_dir: (backup_root+'.0')).run!
      end
      
      describe "#first" do
        it "returns the latest backup" do
          chain.first.path.should == (backup_root+'.0')
        end
      end
      
      describe "#shifting_noah" do
        it "returns a Noah that reuses the latest" do
          
        end
      end
    end
  end
end