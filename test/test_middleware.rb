require "uglify_rack_test"

require "rack/builder"
require "rack/test"

class TestMiddleware < UglifyRack::TestCase
  include Rack::Test::Methods

  class Echo
    def self.call(env)
      if env['PATH_INFO'] == '/test.js'
        [200, {'Content-Type' => 'application/javascript'}, ["var func = function(){ var some_code = 'asdf'; }()"]]
      elsif env['PATH_INFO'] == '/bad-test.js'
        [200, {'Content-Type' => 'application/javascript'}, ['<this><is></not></javascript>']]
      elsif env['PATH_INFO'] == '/test.min.html'
        [200, {'Content-Type' => 'text/html'}, ["var func = function(){ var some_code = 'asdf'; }()"]]
      else
        [404, {}, ["var func = function(){ var some_code = 'asdf'; }()"]]
      end
    end
  end
  def generic_app
    Rack::Builder.new do
      use UglifyRack::Middleware
      run Echo
    end
  end

  def app
    @app ||= generic_app
  end

  test "minify js" do
    get "/test.min.js"

    assert_equal 'var func=function(){var a="asdf"}()', last_response.body
  end

  test "gracefully fail on non-js" do
    get "/bad-test.min.js"

    assert_equal "<this><is></not></javascript>", last_response.body
  end

  test "don't minify non js" do
    get "/test.min.html"
    assert_equal "var func = function(){ var some_code = 'asdf'; }()", last_response.body
  end

  test "don't minify 404" do
    get "/nothing.min.js"
    assert_equal "var func = function(){ var some_code = 'asdf'; }()", last_response.body
  end
end
