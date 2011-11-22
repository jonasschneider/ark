require "ark"

Ark::App.set :manager, Ark::Manager.from_file(File.expand_path('~/.ark/ark.yml'))

run Ark::App