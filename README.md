uglify-rack
=========

Uglify-rack is a rack middleware that compresses javascript on the fly. It looks for requests like /path/to/javascript.min.js, removes the ".min" and runs the resulting javascript through the uglifier gem.
