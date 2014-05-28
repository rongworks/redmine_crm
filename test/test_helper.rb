# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')
require 'factory_girl_rails'
FactoryGirl.definition_file_paths << File.expand_path('../factories', __FILE__)
FactoryGirl.find_definitions
include FactoryGirl::Syntax::Methods
