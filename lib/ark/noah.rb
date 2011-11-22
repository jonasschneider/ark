module Ark
  class Noah
    attr_accessor :backup_dir, :data_dir, :cache_dir, :shift, :log
    
    def initialize options
      @backup_dir = options[:backup_dir]
      @data_dir = options[:data_dir]
      @cache_dir = options[:cache_dir]
      @shift = options[:shift] || []
    end
    
    def run! interactive = false
      @log = ""
      IO.popen(command) do |io|
        io.each do |line|
          @log << line
          puts line if interactive
        end
      end
      aFile = File.new("#{backup_dir}/__ARK__/noah.log", "w")
      aFile.write(@log)
      aFile.close
    end
    
    def stats
      {
        files_total: read_stat('Number of files') - 1, # ignore ./ for good measure
        files_transferred: read_stat('Number of files transferred'),
        size_total: read_stat('Total file size'),
        size_transferred: read_stat('Total transferred file size')
      }

    end

    def read_stat(name)
      $1.to_i if log.lines.detect{|l| l.match(/#{name}: (\d)+.*\n/) }
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
        "rsync -va #{link_option} --stats --delete #{data_dir}/ #{backup_dir}",
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