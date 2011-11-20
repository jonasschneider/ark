describe "Ark::Backup" do
  let(:working_dir) { File.expand_path('env/sandbox', File.dirname(__FILE__)) }
  let(:data_dir) { File.join(working_dir, 'data') }
  let(:backup_dir) { File.join(working_dir, 'backup') }
  
  let(:ark) { Ark::Backup.new data_dir: data_dir, backup_dir: backup_dir }
  
  it "stores the data and backup dir" do
    puts Ark.inspect
    puts Ark::Backup.inspect
    ark.data_dir.should == data_dir
  end
  
  describe "#run" do
    it "creates a file in the backup" do
      
      #Ark.backup
    end
  end
end