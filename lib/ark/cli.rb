require "ap"

module Ark
  class Cli
    def self.run(metadata_path)
      m = Ark::Manager.new(YAML.load(File.read(metadata_path)))
      m.tasks.each do |name, task|
        puts "Running #{name}".green
        puts task.noah.command.white
        task.noah.run!
      end
    end
  end
end