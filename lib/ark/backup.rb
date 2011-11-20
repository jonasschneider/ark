module Ark
  class Backup
    attr_reader :backup_dir, :data_dir
    
    def initialize options
      @backup_dir = options[:backup_dir]
      @data_dir = options[:backup_dir]
    end
  end
end