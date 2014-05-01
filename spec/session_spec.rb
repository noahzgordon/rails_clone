require 'rails_lite'

describe Session do
  let(:req) { WEBrick::HTTPRequest.new(Logger: nil) }
  let(:res) { WEBrick::HTTPResponse.new(HTTPVersion: '1.0') }
  let(:cook) { WEBrick::Cookie.new('_rails_lite_app', { xyz: 'abc' }.to_json) }

  it 'deserializes json cookie if one exists' do
    req.cookies << cook
    session = Session.new(req)
    expect(session['xyz']).to eq('abc')
  end

  describe '#store_session' do
    context 'without cookies in request' do
      subject(:session) { Session.new(req) }

      before(:each) do
        session['first_key'] = 'first_val'
        session.store_session(res)
      end

      it "adds new cookie with '_rails_lite_app' name to response" do
        cookie = res.cookies.find { |c| c.name == '_rails_lite_app' }
        expect(cookie).not_to be_nil
      end

      it 'stores the cookie in json format' do
        cookie = res.cookies.find { |c| c.name == '_rails_lite_app' }
        expect(JSON.parse(cookie.value)).to be_a(Hash)
      end
    end

    context 'with cookies in request' do
      subject(:session) { Session.new(req) }

      before(:each) do
        cook = WEBrick::Cookie.new('_rails_lite_app', { pho: 'soup' }.to_json)
        req.cookies << cook
      end

      it 'reads the pre-existing cookie data into hash' do
        expect(session['pho']).to eq('soup')
      end

      it 'saves new and old data to the cookie' do
        session['machine'] = 'mocha'
        session.store_session(res)
        cookie = res.cookies.find { |c| c.name == '_rails_lite_app' }
        h = JSON.parse(cookie.value)
        expect(h['pho']).to eq('soup')
        expect(h['machine']).to eq('mocha')
      end
    end
  end
end
