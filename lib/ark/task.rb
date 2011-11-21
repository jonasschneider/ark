module Ark
  class Task
    attr_reader :name, :source, :repo
    
    def initialize(name, data)
      @name = name
      @source = data[:source]
      @repo = data[:repo]
    end
    
    def chain
      @repo.chains.detect{|c| c.name == @name.to_s }
    end
    
    def noah
      chain.noah.tap do |noah|
        noah.data_dir = @source.path
      end
    end
  end
end