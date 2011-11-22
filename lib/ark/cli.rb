require "ap"

module Ark
  class Cli
    def self.run(metadata_path, options = {})
      m = Ark::Manager.new(YAML.load(File.read(metadata_path)))
      m.tasks.each do |task|
        unless options[:silent]
          puts "Running #{task.name}".green
          puts task.noah.command.white
        end
        task.noah.run! !options[:silent]
      end
    end
  end
end