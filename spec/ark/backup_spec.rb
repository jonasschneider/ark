require File.expand_path('../env/helper', File.dirname(__FILE__))

describe "Ark::Backup" do
  let(:path) { File.join(SANDBOX_DIR, 'backup') }
  let(:backup) { FileUtils.mkdir(path) && Ark::Backup.new(path) }
  
  describe "#timestamp" do
    it "returns the directory mtime" do
      backup.timestamp.should == File.mtime(path)
    end
  end
end