require 'webrick'

require_relative '../lib/controller_base.rb'
require_relative '../lib/router.rb'
require_relative '../lib/flash.rb'
require_relative '../lib/session.rb'
require_relative '../lib/params.rb'

require_relative '../models/cat.rb'
require_relative '../models/human.rb'
require_relative '../models/house.rb'
require_relative '../controllers/static_pages_controller.rb'
require_relative '../controllers/humans_controller.rb'
require_relative '../controllers/cats_controller.rb'
require_relative '../controllers/houses_controller.rb'

router = Router.new

router.draw do
  get "^/$", StaticPagesController, :home
  
  get "^/humans$", HumansController, :index 
  get "^/humans/new$", HumansController, :new
  post "^/humans$", HumansController, :create
  get "^/humans/(?<human_id>\\d+)$", HumansController, :show
  
  get "^/cats$", CatsController, :index
  get "^/cats/new$", CatsController, :new
  post "^/cats$", CatsController, :create
  get "^/cats/(?<cat_id>\\d+)$", CatsController, :show
  
  get "^/houses$", HousesController, :index
  get "^/houses/new$", HousesController, :new
  post "^/houses$", HousesController, :create
  get "^/houses/(?<house_id>\\d+)$", HousesController, :show
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start