require "yaml"

module Ark
  class Repo
    attr_reader :path
    
    def initialize(source)
      @source = Ark::Source.load(source)
    end
    
    def chains
      @source.glob('*')
        .select{ |path| File.directory?(path) && path.match(/[a-z]+\.\d+/) }
        .map{ |path| File.dirname(path) + '/' + File.basename(path).gsub(/\..*$/, '') }
        .uniq
        .map{ |path| Ark::Chain.new(path) }
    end
  end
end