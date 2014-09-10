require 'webrick'

require_relative '../lib/controller_base.rb'
require_relative '../lib/router.rb'
require_relative '../lib/flash.rb'
require_relative '../lib/session.rb'
require_relative '../lib/params.rb'

require_relative '../models/cat.rb'
require_relative '../models/human.rb'
require_relative '../models/house.rb'
require_relative '../controllers/cats_controller.rb'

router = Router.new

router.draw do
  get "^/cats$", CatsController, :index
  get "^/cats/new$", CatsController, :new
  post "^/cats$", CatsController, :create
  get "^/cats/(?<cat_id>\\d+)$", CatsController, :show
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start