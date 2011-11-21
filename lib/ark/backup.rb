module Ark
  class Backup < Struct.new(:path)
    def timestamp
      File.mtime(path)
    end
    
    def name
      File.basename(path)
    end
  end
end