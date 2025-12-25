# frozen_string_literal: true

require './app'

use Rack::MethodOverride
run Application
