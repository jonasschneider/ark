require "yaml"

module Ark
  class Repo
    attr_reader :source
    
    def initialize(source)
      @source = Ark::Source.load(source)
    end
    
    def chain(name)
      chains.detect{|c| c.name == name } or new_chain(name)
    end
    
    def new_chain(name)
      Ark::Chain.new File.join(source.path, name)
    end
    
    def chains
      # FIXME: File.directory?(path) will not work after disconnecting remote sources
      @source.glob('*')
        .select{ |path| File.directory?(path) && path.match(/[a-z]+\.\d+/) }
        .map{ |path| File.dirname(path) + '/' + File.basename(path).gsub(/\..*$/, '') }
        .uniq
        .map{ |path| Ark::Chain.new(path) }
    end
  end
end