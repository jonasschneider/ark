require "yaml"

module Ark
  class Repo
    attr_reader :path
    
    def initialize(path)
      @path = path
    end
    
    def chains
      Dir[@path+"/*"]
        .select{ |path| File.directory?(path) && path.match(/[a-z]+\.\d+/) }
        .map{ |path| File.dirname(path) + '/' + File.basename(path).gsub(/\..*$/, '') }
        .uniq
        .map{ |path| Ark::Chain.new(path) }
    end
    
    def metadata_for(chain_name)
      metadata ? metadata[chain_name] : nil
    end
    
    protected
    
    def metadata
      return nil unless File.exist?(metadata_path)
      YAML::load(File.read(metadata_path))
    end
    
    def metadata_path
      File.join(@path, 'ark-manifest.yml')
    end
  end
end