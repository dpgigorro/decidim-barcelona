# frozen_string_literal: true

require 'rails'
require 'active_support/all'
require 'omniauth-saml'

module Decidim
  module Saml
    class Engine < ::Rails::Engine

      isolate_namespace Decidim::Saml

      initializer "decidim_saml" do
        # next unless Decidim::Saml.configured?

        Decidim::Saml::Engine.add_saml

        ActiveSupport::Reloader.to_run do
          Decidim::Saml::Engine.add_saml
        end
      end

      initializer "decidim_saml.setup", before: "devise.omniauth" do
        # Configure the SAML OmniAuth strategy for Devise
        if Rails.application.secrets.dig(:omniauth, :saml).present?
          ::Devise.setup do |config|
            config.omniauth :saml,
                            idp_cert_fingerprint: Rails.application.secrets.omniauth[:saml][:idp_cert_fingerprint],
                            idp_sso_target_url: Rails.application.secrets.omniauth[:saml][:idp_sso_target_url],
                            strategy_class: ::OmniAuth::Strategies::SAML
          end
        end
      end

      def self.add_saml
        # Add :saml to the Decidim omniauth providers
        providers = ::Decidim::User::OMNIAUTH_PROVIDERS
        unless providers.include?(:saml)
          providers << :saml
          ::Decidim::User.send(:remove_const, :OMNIAUTH_PROVIDERS)
          ::Decidim::User.const_set(:OMNIAUTH_PROVIDERS, providers)
        end
      end

    end
  end
end
