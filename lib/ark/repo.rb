module Ark
  class Repo
    def initialize(root)
      @root = root
    end
    
    def chains
      Dir[@root+"/*"].map{|path| File.dirname(path) + '/' + File.basename(path).gsub(/\..*$/, '')}.uniq.map{ |p| Ark::Chain.new p }
    end
  end
end