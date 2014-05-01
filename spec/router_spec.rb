require 'webrick'
require 'rails_lite'

describe Route do
  let(:req) { WEBrick::HTTPRequest.new(Logger: nil) }
  let(:res) { WEBrick::HTTPResponse.new(HTTPVersion: '1.0') }

  describe '#matches?' do
    before(:each) do
      allow(req).to receive(:request_method) { :get }
    end

    it 'matches simple regular expression' do
      index_route = Route.new(Regexp.new('^/users$'), :get, 'x', :x)
      allow(req).to receive(:path) { '/users' }
      expect(index_route).to be_matches(req)
    end

    it 'matches regular expression with capture' do
      index_route = Route.new(Regexp.new('^/users/(?<id>\\d+)$'), :get, 'x', :x)
      allow(req).to receive(:path) { '/users/1' }
      expect(index_route).to be_matches(req)
    end

    it "correctly doesn't matche regular expression with capture" do
      index_route = Route.new(
        Regexp.new('^/users/(?<id>\\d+)$'),
        :get,
        'UsersController',
        :index
      )
      allow(req).to receive(:path) { '/statuses/1' }
      expect(index_route).not_to be_matches(req)
    end
  end

  describe '#run' do
    it 'instantiates controller and invokes action' do
      # reader beware. hairy adventures ahead.
      # this is really checking way too much implementation,
      # but tests the aproach recommended in the project
      allow(req).to receive(:path) { '/users' }
      class DummyController; end
      dummy_controller_class = DummyController
      dummy_controller_instance = DummyController.new
      allow(dummy_controller_instance).to receive(:invoke_action)
      allow(dummy_controller_class).to receive(:new).with(req, res) do
        dummy_controller_instance
      end
      allow(dummy_controller_class).to receive(:new).with(req, res, {}) do
        dummy_controller_instance
      end
      expect(dummy_controller_instance).to receive(:invoke_action)
      index_route = Route.new(
        Regexp.new('^/users$'),
        :get,
        dummy_controller_class,
        :index
      )
      index_route.run(req, res)
    end
  end
end

describe Router do
  subject(:router) { Router.new }
  let(:req) { WEBrick::HTTPRequest.new(Logger: nil) }
  let(:res) { WEBrick::HTTPResponse.new(HTTPVersion: '1.0') }
  let(:dummy_path) { Regexp.new("$^") }

  before(:each) do
    allow(req).to receive(:request_method) { :get }
  end

  describe '#add_route' do
    it 'adds a route' do
      router.add_route(dummy_path, 2, 3, 4)
      expect(router).to have(1).routes
      router.add_route(dummy_path, 2, 3, 4)
      router.add_route(dummy_path, 2, 3, 4)
      expect(router).to have(3).routes
    end
  end

  describe '#match' do
    it 'matches a correct route' do
      router.add_route(Regexp.new('^/users$'), :get, :x, :x)
      allow(req).to receive(:path) { '/users' }
      matched = router.match(req)
      expect(matched).not_to be_nil
    end

    it "doesn't match an incorrect route" do
      router.add_route(Regexp.new('^/users$'), :get, :x, :x)
      allow(req).to receive(:path) { '/incorrect_path' }
      matched = router.match(req)
      expect(matched).to be_nil
    end
  end

  describe '#run' do
    it 'sets status to 404 if no route is found' do
      router.add_route(dummy_path, 2, 3, 4)
      allow(req).to receive(:path) { '/users' }
      router.run(req, res)
      res.status.should == 404
    end
  end

  describe 'http method (get, put, post, delete)' do
    it 'adds methods get, put, post and delete' do
      expect(router.methods).to include(:get, :put, :post, :delete)
    end

    it 'adds a route when an http method method is called' do
      router.get(Regexp.new('^/users$'), ControllerBase, :index)
      expect(router).to have(1).routes
    end
  end
end
