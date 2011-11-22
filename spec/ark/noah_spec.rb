require File.expand_path('../env/helper', File.dirname(__FILE__))

describe "Ark::Noah" do
  let(:data_dir) { File.join(SANDBOX_DIR, 'data') }
  let(:backup_dir) { File.join(SANDBOX_DIR, 'backup') }
  
  before :each do
    FileUtils.mkdir(data_dir)
  end
  
  let(:noah) { Ark::Noah.new data_dir: data_dir, backup_dir: backup_dir }
  
  it "stores the data and backup dir" do
    noah.data_dir.should == data_dir
    noah.backup_dir.should == backup_dir
  end
  
  describe "#shift_commands" do
    it "is empty" do
      noah.shift_commands.should == []
    end
  
    describe "with shifting enabled" do
      let(:noah) { Ark::Noah.new data_dir: data_dir, backup_dir: backup_dir, shift: ['1', '2', '3'] }
      
      it "removes the last, shifts the others and creates a new empty target dir" do
        noah.shift_commands.should == ["mv 3 4", "mv 2 3", "mv 1 2", "mkdir #{backup_dir}"]
        noah.rm_commands.should == ["rm -rf 4"]
      end
    end
  end
  
  describe "after #run! with a file in the data directory" do
    before :each do
      put_file File.join(data_dir, 'test.txt'), 'lol'
      noah.run!
    end
    
    describe "#log" do
      it "returns a log object" do
        noah.log.should be_kind_of(Ark::RsyncLog)
        noah.log.text.should_not be_empty
      end
    end
  end
  
  describe "#run!" do
    it "does not print to stdout by default" do
      capture_stdout do
        noah.run!
      end.should be_empty
    end
    
    it "does print to stdout when called with true" do
      capture_stdout do
        noah.run! true
      end.should_not be_empty
    end
    
    it "adds a new file to the backup" do
      put_file File.join(data_dir, 'test.txt'), 'ohai'
      
      noah.run!
      
      File.read(File.join(backup_dir, 'test.txt')).should == 'ohai'
    end
    
    describe "multiple times" do
      let(:first_backup_dir) { File.join(SANDBOX_DIR, 'backup.1') }
      let(:second_backup_dir) { File.join(SANDBOX_DIR, 'backup.0') }
      
      let(:first_noah) { Ark::Noah.new data_dir: data_dir, backup_dir: first_backup_dir }
      let(:second_noah) { Ark::Noah.new data_dir: data_dir, backup_dir: second_backup_dir, cache_dir: first_backup_dir }
      
      it "adds a changed file to the backup" do
        put_file File.join(data_dir, 'test.txt'), 'ohai'
        first_noah.run!
        
        put_file File.join(data_dir, 'test.txt'), 'changed'
        second_noah.run!
        
        File.read(File.join(backup_dir+'.1', 'test.txt')).should == 'ohai'
        File.read(File.join(backup_dir+'.0', 'test.txt')).should == 'changed'
      end
      
      it "removes files from the backup" do
        put_file File.join(data_dir, 'test.txt'), 'ohai'
        first_noah.run!
        
        FileUtils.rm File.join(SANDBOX_DIR, 'data/test.txt')
        second_noah.run!
        
        File.exists?(File.join(SANDBOX_DIR, 'backup.0/test.txt')).should == false
      end
      
      it "reuses inodes" do
        put_file File.join(data_dir, 'test.txt'), 'ohai'
        first_noah.run!
        second_noah.run!
        File.stat("#{second_backup_dir}/test.txt").ino.should == File.stat("#{first_backup_dir}/test.txt").ino
      end
    end
    
    it "puts the log text in backup.0/__ARK__/noah.log" do
      noah.run!
      
      File.read(File.join(backup_dir, '__ARK__/noah.log')).should == noah.log.text
    end
  end
end