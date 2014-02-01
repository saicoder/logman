require "logman/version"

require 'mongoid'
require 'sinatra'
require "sinatra/json"

# models
require 'models/user'
require 'models/bucket'
require 'models/log'

# modules
require 'modules/log_writer'
require '/console/web_console'


require "logman/system"

