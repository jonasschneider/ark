module Ark
  class Noah
    attr_reader :backup_dir, :data_dir, :cache_dir, :shift
    
    def initialize options
      @backup_dir = options[:backup_dir]
      @data_dir = options[:data_dir]
      @cache_dir = options[:cache_dir]
      @shift = options[:shift] || []
    end
    
    def run!
      joined = commands.join(" && ")
      `#{joined}`
    end
    
    def shift_commands
      return [] if shift.empty?
      moves = [].tap do |moves|
        shift.each_with_index do |dir, i|
          next if i == shift.length-1
          moves << "mv #{dir} #{shift[i+1]}"
        end
      end
      ["rm -rf #{shift.last}"] + moves.reverse
    end
    
    def link_option
      if cache_dir
        "--link-dest=#{cache_dir}"
      else
        ""
      end
    end
    
    def rsync_command
      "rsync -va #{link_option} --delete #{data_dir}/ #{backup_dir}"
    end
    
    def commands
      shift_commands + [rsync_command]
    end
  end
end