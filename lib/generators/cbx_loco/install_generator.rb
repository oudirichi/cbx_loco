require 'rails/generators'

module CbxLoco
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Creates a CbxLoco initializer and copy locale files to your application."

      source_root File.expand_path("../../../templates", __FILE__)

      def copy_initializer
        template "cbx_loco.rb", "config/initializers/cbx_loco.rb"
      end
    end
  end
end
