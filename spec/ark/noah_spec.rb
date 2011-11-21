require File.expand_path('../env/helper', File.dirname(__FILE__))

describe "Ark::Noah" do
  let(:data_dir) { File.join(SANDBOX_DIR, 'data') }
  let(:backup_dir) { File.join(SANDBOX_DIR, 'backup') }
  
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
      
      it "removes the last and shifts the others" do
        noah.shift_commands.should == ["rm -rf 3", "mv 2 3", "mv 1 2"]
      end
    end
  end
  
  describe "#run!" do
    it "adds a new file to the backup" do
      put_file 'data/test.txt', 'ohai'
      
      noah.run!
      
      get_file('backup/test.txt').should == 'ohai'
    end
    
    describe "multiple times" do
      let(:first_backup_dir) { File.join(SANDBOX_DIR, 'backup.1') }
      let(:second_backup_dir) { File.join(SANDBOX_DIR, 'backup.0') }
      
      let(:first_noah) { Ark::Noah.new data_dir: data_dir, backup_dir: first_backup_dir }
      let(:second_noah) { Ark::Noah.new data_dir: data_dir, backup_dir: second_backup_dir, cache_dir: first_backup_dir }
      
      it "adds a changed file to the backup" do
        put_file 'data/test.txt', 'ohai'
        first_noah.run!
        
        put_file 'data/test.txt', 'changed'
        second_noah.run!
        
        get_file('backup.1/test.txt').should == 'ohai'
        get_file('backup.0/test.txt').should == 'changed'
      end
      
      it "removes files from the backup" do
        put_file 'data/test.txt', 'ohai'
        first_noah.run!
        
        FileUtils.rm File.join(SANDBOX_DIR, 'data/test.txt')
        second_noah.run!
        
        File.exists?(File.join(SANDBOX_DIR, 'backup.0/test.txt')).should == false
      end
      
      it "reuses inodes" do
        put_file 'data/test.txt', 'ohai'
        first_noah.run!
        second_noah.run!
        File.stat("#{second_backup_dir}/test.txt").ino.should == File.stat("#{first_backup_dir}/test.txt").ino
      end
    end
  end
end