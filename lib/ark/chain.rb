module Ark
  class Chain
    include Enumerable
    
    def initialize(prefix)
      @prefix = prefix
      @dirs = Dir[@prefix+'*'].sort{|a, b| File.mtime(a) <=> File.mtime(b) }
      @backups = @dirs.map{ |d| Ark::Backup.new d }
    end
    
    def each &block
      @backups.each &block
    end
  end
end