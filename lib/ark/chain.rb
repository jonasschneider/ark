module Ark
  class Chain
    include Enumerable
    
    def initialize(prefix)
      @prefix = prefix
      @dirs = Dir[@prefix+'*'].sort
      
      @backups = @dirs.map{ |dir| Ark::Backup.new(dir) }
      @backups.each_with_index do |backup, i|
        next if i == 0
        raise "Bogus directory structure - #{dir} is newer than #{last_dir}" if backup.timestamp > @backups[i-1].timestamp
      end
    end
    
    def each &block
      @backups.each &block
    end
  end
end