Gem::Specification.new do |s|
  s.name = "uglify-rack"
  s.version = "0.1.0"
  s.summary = "Rack-based middleware to uglifier (ie: minimize) Javascript as it's served"
  s.description = "uglify-rack is a tiny Rack middleware that passes javascript through the Node's uglify utility before they're served."

  s.files = Dir["Rakefile", "lib/**/*"]

  s.add_dependency "rack", ">= 1.0.0"
  s.add_dependency "uglifier"

  s.authors = ["Kurt Mackey"]
  s.email = "mrkurt@gmail.com"
  s.homepage = "http://github.com/mrkurt/uglify-rack/"
end
