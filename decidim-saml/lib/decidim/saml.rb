# frozen_string_literal: true

require 'decidim/saml/engine'
require 'decidim/saml/configuration'

module Decidim
  # Base module for this engine.
  module Saml
    def self.configure
      yield(configuration)
    end

    def self.configuration
      @configuration ||= Configuration.new
    end
  end
end
