module Ark
  class Noah
    attr_accessor :backup_dir, :data_dir, :cache_dir, :shift, :log
    
    def initialize options
      @backup_dir = options[:backup_dir]
      @data_dir = options[:data_dir]
      @cache_dir = options[:cache_dir]
      @shift = options[:shift] || []
      @log = nil
      @after_hook = lambda {  }
    end
    
    def after &block
      @after_hook = block
    end
    
    def run! interactive = false
      raise "Need backup_dir and data_dir - #{self.inspect}" unless backup_dir && data_dir
      log = ""
      IO.popen(command) do |io|
        io.each do |line|
          log << line
          puts line if interactive
        end
      end
      @log = Ark::RsyncLog.new(log)
      @after_hook.arity == 1 ? @after_hook.call(self) : @after_hook.call
    end
    
    def shift_commands
      return [] if shift.empty?
      moves = [].tap do |moves|
        shift.each_with_index do |dir, i|
          target = i == shift.length-1 ? dir.succ : shift[i+1]
          moves << "mv #{dir} #{target}"
        end
      end
      moves.reverse + ["mkdir #{backup_dir}"]
    end
    
    def rm_commands
      return [] if shift.empty?
      ["rm -rf #{shift.last.succ}"]
    end
    
    def link_option
      if cache_dir
        "--link-dest=#{cache_dir}"
      else
        ""
      end
    end
    
    def rsync_commands
      [
        "rsync -va #{link_option} --stats --delete-after #{data_dir}/ #{backup_dir}",
        "touch #{backup_dir}",
        "mkdir #{backup_dir}/__ARK__"
      ]
    end
    
    def commands
      shift_commands + rsync_commands + rm_commands
    end
    
    def command
      commands.join(" && ")
    end
  end
end