module Ark
  class Source
    def self.load(thing)
      if thing.kind_of? self
        thing
      else
        new(:fs, thing)
      end
    end
    
    attr_reader :path
    
    def initialize(type, path)
      @path = path
    end
    
    def connect
      yield @path
    end
    
    def glob(globexp)
      val = nil
      connect do |connected_path|
        val = Dir["#{connected_path}/#{globexp}"]
      end
      val
    end
  end
end