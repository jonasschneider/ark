module Ark
  class Noah
    attr_reader :backup_dir, :data_dir, :cache_dir
    
    def initialize options
      @backup_dir = options[:backup_dir]
      @data_dir = options[:data_dir]
      @cache_dir = options[:cache_dir]
    end
    
    def run!
      if cache_dir
        `cp -al #{cache_dir} #{backup_dir}`
      end
      
      `rsync -va --delete #{data_dir}/ #{backup_dir}`
    end
  end
end