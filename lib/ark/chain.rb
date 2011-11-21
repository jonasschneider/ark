module Ark
  class Chain
    include Enumerable
    attr_reader :path
    
    def initialize(path)
      @path = path
      
      @backups = []
      
      while File.exists?(dir = "#{path}.#{@backups.length}")
        @backups << Ark::Backup.new(dir)
      end
      raise "Bogus directory structure - Hole found after #{@backups.last.name}" unless @backups.length == Dir["#{path}.*"].length
      
      @backups.each_with_index do |backup, i|
        next if i == 0
        raise "Bogus directory structure - #{backup.name} is newer than #{@backups[i-1].name}" if backup.timestamp > @backups[i-1].timestamp
      end
    end
    
    def prefix
      File.dirname(@path)
    end
    
    def name
      File.basename(@path)
    end
    
    def each &block
      @backups.each &block
    end
    
    def shifting_noah
      Ark::Noah.new(backup_dir: "#{path}.0", cache_dir: "#{path}.1")
    end
  end
end