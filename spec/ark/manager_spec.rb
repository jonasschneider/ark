require File.expand_path('../env/helper', File.dirname(__FILE__))

describe "Ark::Manager" do
  describe ".from_metadata" do
    it "loads repos" do
      m = Ark::Manager.new(repos: { one: '/tmp/ark/one' })
      m.repos[:one].source.path.should == '/tmp/ark/one'
    end
  end
  
  describe "with a repo and a task" do
    let(:manager) { Ark::Manager.new repos: { one: '/tmp/ark/one' }, tasks: { hellobup: { source: '/home/jonas/hello', repo: :one} } }
    
    it "sees the task" do
      manager.tasks[:hellobup].source.path.should == '/home/jonas/hello'
      manager.tasks[:hellobup].repo.source.path.should == '/tmp/ark/one'
    end
  end
end