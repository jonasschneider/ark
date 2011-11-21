module Ark
  class Manager
    def initialize(metadata)
      @metadata = metadata
    end
    
    def repos
      @repos ||= begin
        x = {}
        @metadata[:repos].each do |name, source|
          x[name] = Ark::Repo.new(source)
        end
        x
      end
    end
    
    def tasks
      @tasks ||= begin
        x = {}
        @metadata[:tasks].each do |name, data|
          x[name] = Ark::Task.new(name, source: Ark::Source.load(data[:source]), repo: repos[data[:repo]])
        end
        x
      end
    end
    
  end
end