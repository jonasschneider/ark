module Ark
  class Repo
    attr_reader :path
    
    def initialize(path)
      @path = path
    end
    
    def chains
      Dir[@path+"/*"]
        .select{ |path| File.directory?(path) && path.match(/[a-z]+\.\d+/) }
        .map{ |path| File.dirname(path) + '/' + File.basename(path).gsub(/\..*$/, '') }
        .uniq
        .map{ |path| Ark::Chain.new(path) }
    end
  end
end