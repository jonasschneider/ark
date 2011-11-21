require "ark"

Ark::App.set :repo, Ark::Repo.new('/tmp/arkrepo')

run Ark::App