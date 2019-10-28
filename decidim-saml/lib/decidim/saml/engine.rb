# frozen_string_literal: true

require 'rails'
require 'active_support/all'
require 'devise_saml_authenticatable'

module Decidim
  module Saml
    class Engine < ::Rails::Engine

      isolate_namespace Decidim::Saml

      routes do
        devise_scope :user do
          match(
            "/users/saml/sign_in",
            to: "/devise/saml_sessions#new",
            via: [:get]
          )

          match(
            "/users/saml/auth",
            to: "/devise/saml_sessions#create",
            via: [:post]
          )
        end
      end

      initializer 'decidim_saml.devise_with_saml' do
        ::Devise.setup do |config|
          $callback = Rails.env.development? ? 'http://localhost:3000' : ENV['CALLBACK_ADDRESS']

          config.saml_create_user = true
          config.saml_update_user = true
          config.saml_default_user_key = :email
          config.saml_session_index_key = :session_index
          config.saml_use_subject = true
          config.idp_settings_adapter = nil
          config.saml_configure do |settings|
            settings.assertion_consumer_service_url     = "#{$callback}/users/saml/auth"
            settings.assertion_consumer_service_binding = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
            settings.name_identifier_format             = "urn:oasis:names:tc:SAML:2.0:nameid-format:transient"
            settings.issuer                             = "#{$callback}/users/saml/metadata"
            settings.authn_context                      = ""
            settings.idp_slo_target_url                 = ""
            settings.idp_sso_target_url                 = "https://aspgems-dperez.okta.com/app/aspgemsorg511359_pruebadecidim_1/exk1oj3ycuyvRClrc357/sso/saml"
            settings.idp_cert_fingerprint               = '4F:99:F2:69:3B:F8:BD:1E:F2:15:09:10:2F:C5:5A:86:9D:4F:CA:83:1A:05:00:67:78:93:23:87:6E:06:35:02'
            settings.idp_cert_fingerprint_algorithm     = 'http://www.w3.org/2000/09/xmldsig#sha256'
          end

        end
      end

    end
  end
end
