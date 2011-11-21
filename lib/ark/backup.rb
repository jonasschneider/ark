module Ark
  class Backup < Struct.new(:path)
    def timestamp
      File.mtime(path)
    end
    
    def name
      File.basename(path)
    end
    
    def id
      timestamp.to_i.to_s
    end
    
    def files
      Dir[path+"/*"].map{|file| File.expand_path(file, path)}
    end
  end
end