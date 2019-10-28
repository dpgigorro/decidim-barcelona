# frozen_string_literal: true
# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

require 'decidim/saml/extensions/devise_with_saml'
Decidim::Devise::SessionsController
  .include(Decidim::Saml::Extensions::SessionsControllerWithSaml)
Decidim::Devise::RegistrationsController
  .include(Decidim::Saml::Extensions::RegistrationsControllerWithSaml)

