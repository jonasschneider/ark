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
      raise "Bogus directory structure - Backup 0 missing" if @backups.length == 0 && Dir["#{path}.*"].length > 0
      raise "Bogus directory structure - Hole found after #{@backups.last.name}" unless @backups.length == Dir["#{path}.*"].length
      
      @backups.each_with_index do |backup, i|
        next if i == 0
        raise "Bogus directory structure - #{backup.name} is newer than #{@backups[i-1].name}" if backup.timestamp > @backups[i-1].timestamp
      end
    end
    
    def name
      File.basename(@path)
    end
    
    def backups
      @backups
    end
    
    def each &block
      @backups.each &block
    end
    
    def noah
      if @backups.length == 0
        Ark::Noah.new(backup_dir: "#{path}.0")
      else
        Ark::Noah.new(backup_dir: "#{path}.0", cache_dir: "#{path}.1", shift: @backups.map{|b|b.path})
      end
    end
    
    def repo_path
      File.dirname(@path)
    end
    
    def repo
      Ark::Repo.new repo_path
    end
  end
end