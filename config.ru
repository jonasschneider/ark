require "ark"

Ark::App.set :manager, Ark::Manager.from_file(File.expand_path('~/ark_config.yml'))

run Ark::App