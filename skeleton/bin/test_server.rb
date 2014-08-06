require 'webrick'

require_relative '../lib/controller_base.rb'
require_relative '../lib/router.rb'
require_relative '../lib/flash.rb'
require_relative '../lib/session.rb'
require_relative '../lib/params.rb'

require_relative './cat.rb'
require_relative './cats_controller.rb'

router = Router.new

router.draw do
  get Regexp.new("^/cats$"), CatsController, :index
  get Regexp.new("^/cats/new$"), CatsController, :new
  post Regexp.new("^/cats$"), CatsController, :create
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start