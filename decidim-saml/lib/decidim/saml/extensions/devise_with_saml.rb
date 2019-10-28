module Decidim
  module Saml
    module Extensions
      module SessionsControllerWithSaml
        extend ActiveSupport::Concern

        def create
          self.resource = warden.authenticate!(authentication_strategy, auth_options)
          set_flash_message!(:notice, :signed_in)
          sign_in(resource_name, resource)
          yield resource if block_given?
          respond_with resource, location: after_sign_in_path_for(resource)
        end

        private

        def sign_in_params
          devise_parameter_sanitizer.permit(:sign_up,
                                            keys: %i(email name password remember_me))
        end

        def authentication_strategy
          return :saml_authenticatable

          :database_authenticatable
        end
      end

      module RegistrationsControllerWithSaml
        extend ActiveSupport::Concern

        included do
          before_action :disable_when_organization_has_saml
        end

        private

        def disable_when_organization_has_saml
          redirect_to decidim.new_user_session_path
        end
      end
    end
  end
end
