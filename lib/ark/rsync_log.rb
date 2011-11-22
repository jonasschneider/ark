module Ark
  class RsyncLog
    attr_reader :text
    
    def initialize(text)
      @text = text
    end
    
    def lines
      @text.lines
    end
    
    def files_total
      read_stat('Number of files') - 1
    end
    
    def files_transferred
      read_stat('Number of files transferred')
    end
    
    def size_total
      read_stat('Total file size')
    end
    
    def size_transferred
      read_stat('Total transferred file size')
    end
    
    def changed_files
      started = false
      changed = []
      @text.lines.each do |line|
        started = false if line.strip.empty?
        
        changed << "/#{line.strip}" if started && !(line.strip =~ /\/$/)
        
        started = true if line =~ /sending incremental file list/
      end
      changed
    end
    
    protected

    def read_stat(name)
      $1.to_i if lines.detect{|l| l.match(/#{name}: (\d+)( bytes)?\n/) }
    end
  end
end