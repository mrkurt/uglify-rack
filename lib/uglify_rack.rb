require 'uglifier'
module UglifyRack
  class Middleware
    attr_accessor :app
    def initialize(app)
      self.app = app
    end

    def call(env)
      minify = needs_min?(env)

      status, headers, body = app.call(env)

      minify = minify && status == 200

      body = uglify(headers, body) if minify

      [status, headers, body]
    end

    def needs_min?(env)
      if env['PATH_INFO'] =~ /(.+)\.min.js$/
        env['uglify.path_info_original'] = env['PATH_INFO']
        env['PATH_INFO'] = "#{$1}.js"
        true
      else
        false
      end
    end

    def uglify(headers, body)
      js = []
      body.each do |s|
        js << s
      end
      body.close if body.respond_to?(:close)

      begin
        output = Uglifier.new.compile(js.join)
        headers['Uglify'] = 'No-Alibi'
        [output]
      rescue Uglifier::Error
        js #already called close, need new array
      end
    end
  end
end
