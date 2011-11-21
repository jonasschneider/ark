require File.expand_path('../env/helper', File.dirname(__FILE__))

describe "Ark::Backup" do
  it "works" do
    get '/'
    last_response.body.should include('ohai')
  end
end