require File.expand_path('../env/helper', File.dirname(__FILE__))

describe "Ark::Backup" do
  let(:data_dir) { File.join(SANDBOX_DIR, 'data') }
  let(:backup_dir) { File.join(SANDBOX_DIR, 'backup') }
  
  let(:ark) { Ark::Backup.new data_dir: data_dir, backup_dir: backup_dir }
  
  it "stores the data and backup dir" do
    ark.data_dir.should == data_dir
    ark.backup_dir.should == backup_dir
  end
  
  describe "#run!" do
    it "adds a file to the backup" do
      put_file 'data/test.txt', 'ohai'
      
      ark.run!
      
      get_file('backup/test.txt').should == 'ohai'
    end
  end
end