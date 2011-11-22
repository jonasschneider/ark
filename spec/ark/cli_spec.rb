require File.expand_path('../env/helper', File.dirname(__FILE__))

describe "Ark::Cli" do
  let(:repo_path) { File.join(SANDBOX_DIR, 'repo') }
  let(:data_path) { File.join(SANDBOX_DIR, 'data') }
  let(:metadata_path) { File.join(SANDBOX_DIR, 'metadata.yml') }
  
  let(:file_content) { 'my content' }
  
  before :each do
    FileUtils.mkdir repo_path
    FileUtils.mkdir data_path
    FileUtils.mkdir File.join(repo_path, 'bup.0')
    put_file File.join(data_path, 'data.txt'), file_content
    put_file metadata_path, YAML.dump(repos: { mine: repo_path }, tasks: { bup: { source: data_path, repo: :mine }})
  end
  
  it "runs the tasks" do
    Ark::Cli.run metadata_path, silent: true
    
    r = Ark::Repo.new repo_path
    File.read(File.join(repo_path, 'bup.0/data.txt')).should == file_content
  end
end