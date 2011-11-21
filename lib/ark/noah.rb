module Ark
  class Noah
    attr_accessor :backup_dir, :data_dir, :cache_dir, :shift
    
    def initialize options
      @backup_dir = options[:backup_dir]
      @data_dir = options[:data_dir]
      @cache_dir = options[:cache_dir]
      @shift = options[:shift] || []
    end
    
    def run!
      `#{command}`
    end
    
    def shift_commands
      return [] if shift.empty?
      moves = [].tap do |moves|
        shift.each_with_index do |dir, i|
          target = i == shift.length-1 ? "#{dir}.tmp" : shift[i+1]
          moves << "mv #{dir} #{target}"
        end
      end
      moves.reverse
    end
    
    def rm_commands
      return [] if shift.empty?
      ["rm -rf #{shift.last}.tmp"]
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
      shift_commands + [rsync_command] + rm_commands
    end
    
    def command
      commands.join(" && ")
    end
  end
end