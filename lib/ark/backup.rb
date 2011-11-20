module Ark
  class Backup
    attr_reader :backup_dir, :data_dir
    
    def initialize options
      @backup_dir = options[:backup_dir]
      @data_dir = options[:data_dir]
    end
    
    def run!
      puts `rsync -r #{data_dir}/ #{backup_dir}`
    end
  end
end