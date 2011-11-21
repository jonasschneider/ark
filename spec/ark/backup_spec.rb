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
end