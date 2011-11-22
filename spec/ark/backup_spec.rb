require File.expand_path('../env/helper', File.dirname(__FILE__))

describe "Ark::Backup" do
  let(:path) { File.join(SANDBOX_DIR, 'backup') }
  before :each do
    FileUtils.mkdir(path)
  end
  let(:backup) { Ark::Backup.new(path) }
  
  describe "#timestamp" do
    it "returns the directory mtime" do
      backup.timestamp.should == File.mtime(path)
    end
  end
  
  describe "#name" do
    it "returns last directory name" do
      backup.name.should == 'backup'
    end
  end
  
  describe "#files" do
    it "return the top-level files" do
      put_file(File.join(path, 'test.txt'), 'lol')
      backup.files.should == [File.join(path, 'test.txt')]
    end
  end
  
  describe "#log" do
    it "reads backup.0/__ARK__/noah.log" do
      put_file File.join(path, '__ARK__/noah.log'), 'ohai'
      backup.log.text.should == 'ohai'
    end
    
    it "returns nil when the file doesn't exist" do
      File.should_receive(:exists?).with(File.join(path, '__ARK__/noah.log')).and_return(false)
      backup.log.should == nil
    end
  end
  
  describe "#files_total et cetera" do
    it "delegates to #log" do
      backup.should_receive(:log).and_return(stub(:files_total => 1337))
      backup.files_total.should == 1337
    end
  end
end