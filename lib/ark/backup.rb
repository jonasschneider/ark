module Ark
  class Backup < Struct.new(:path)
    def timestamp
      File.mtime(path)
    end
  end
end