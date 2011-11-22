require "active_support/core_ext/module/delegation"

module Ark
  class Backup < Struct.new(:path)
    delegate :files_total, :files_transferred, :size_total, :size_transferred, :changed_files, to: :log, allow_nil: true
    
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
      Dir[path+"/*"].map{|file| file.gsub(path, '')}
    end
    
    def log
      if File.exists?(logpath = File.join(path, '__ARK__/noah.log'))
        Ark::RsyncLog.new(File.read(logpath))
      else
        nil
      end
    end
  end
end