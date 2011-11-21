module Ark
  class Repo
    def initialize(root)
      @root = root
    end
    
    def chains
      Dir[@root+"/*"]
        .select{ |path| File.directory?(path) && path.match(/[a-z]+\.\d+/) }
        .map{ |path| File.dirname(path) + '/' + File.basename(path).gsub(/\..*$/, '') }
        .uniq
        .map{ |path| Ark::Chain.new(path) }
    end
  end
end