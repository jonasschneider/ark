require File.expand_path('../env/helper', File.dirname(__FILE__))

describe "Ark::Source" do
  describe ".new" do
    it "accepts a type of :fs and presents the path on #connect" do
      s = Ark::Source.new :fs, '/home/jonas/hello'
      
      passed_path = nil
      s.connect do |path|
        passed_path = path
      end
      passed_path.should == '/home/jonas/hello'
    end
  end
  
  describe ".load" do
    it "interprets a string as path" do
      Ark::Source.should_receive(:new).with(:fs, '/home/jonas/hello')
      Ark::Source.load('/home/jonas/hello')
    end
  end
  
  describe "#glob" do
    it "globs" do
      Dir.should_receive(:[]).with('/home/jonas/hello/*.txt').and_return(['/home/jonas/hello/hello.txt'])
      Ark::Source.load('/home/jonas/hello').glob('*.txt')
    end
  end
end