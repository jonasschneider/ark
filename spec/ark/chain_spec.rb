require File.expand_path('../env/helper', File.dirname(__FILE__))

describe "Ark::Chain" do
  let(:data_dir) { File.join(SANDBOX_DIR, 'data') }
  let(:backup_root) { File.join(SANDBOX_DIR, 'backup') }
  
  before :each do
    put_file 'data/hello.txt', 'ohai'
    put_file 'data/data', 'constant'
    Ark::Noah.new(data_dir: data_dir, backup_dir: (backup_root+'.c')).run!
    put_file 'data/hello.txt', 'changed'
    Ark::Noah.new(data_dir: data_dir, backup_dir: (backup_root+'.a')).run!
    Ark::Noah.new(data_dir: data_dir, backup_dir: (backup_root+'.b')).run!
  end
  
  let(:chain) { Ark::Chain.new backup_root }
  
  describe "#first" do
    it "returns the latest backup" do
      chain.first.path.should == (backup_root+'.b')
    end
  end
end