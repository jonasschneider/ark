require File.expand_path('../env/helper', File.dirname(__FILE__))

describe "Ark::RsyncLog" do
  let(:log_text) do
    <<-END
sending incremental file list
./
Zany/
Zany/Pendulum.mp3
test.txt

Number of files: 3
Number of files transferred: 2
Total file size: 15 bytes
Total transferred file size: 10 bytes
Literal data: 15 bytes
Matched data: 0 bytes
File list size: 59
File list generation time: 0.001 seconds
File list transfer time: 0.000 seconds
Total bytes sent: 169
Total bytes received: 50

sent 169 bytes  received 50 bytes  438.00 bytes/sec
total size is 15  speedup is 0.07
END
  end
  
  let(:log) { Ark::RsyncLog.new(log_text) }
  
  it "#text" do
    log.text.should == log_text
  end
  
  it "#lines" do
    log.lines.should be_kind_of(Enumerable)
  end
  
  describe "#changed_files" do
    it "returns the rsync incremental file list without folders" do
      log.changed_files.should == %w(/Zany/Pendulum.mp3 /test.txt)
    end
  end
  
  it "works" do
    log.files_total.should == 2 # ignore ./ for good measure
    log.files_transferred.should == 2
    log.size_total.should == 15
    log.size_transferred.should == 10
  end
end