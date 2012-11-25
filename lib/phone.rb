require 'serialport'
require 'active_support/inflector'
require 'yaml'
require "phone/base"
require "phone/version"
require "phone/sortmessageservice"

module Phone
  def self.root
   File.expand_path '../', __FILE__
  end
end
Phone::configure
