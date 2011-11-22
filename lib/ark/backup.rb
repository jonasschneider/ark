require "active_support/core_ext/module/delegation"

module Ark
  class Backup < Struct.new(:path)
    delegate :files_total, :files_transferred, :size_total, :size_transferred, to: :log
    
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
    
    def log
      Ark::RsyncLog.new(File.read(File.join(path, '__ARK__/noah.log')))
    end
  end
end