module Ark
  class Source
    def self.load(path)
      new(:fs, path)
    end
    
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