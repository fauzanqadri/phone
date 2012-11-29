require 'serialport'
require 'active_support/inflector'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/object/instance_variables'
require 'active_support/callbacks'
require 'yaml'
require "phone/base"
require "phone/version"
require "phone/message"

module Phone
  def self.root
   File.expand_path '../', __FILE__
  end
end
beginning_time = Time.now
Phone::configure
end_time = Time.now
puts "Time elapsed #{(end_time - beginning_time)*1000} milliseconds"
