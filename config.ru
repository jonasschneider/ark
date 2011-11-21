require "ark"

data = YAML.load(File.expand_path('~/ark_config.yml'))

Ark::App.set :manager, Ark::Manager.new(data)

run Ark::App