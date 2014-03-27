require 'rack/test'
require 'minitest/autorun'

d = File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH.unshift File.expand_path(d)

require 'rulers'
