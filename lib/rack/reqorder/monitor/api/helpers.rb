module Rack::Reqorder::Monitor::Api
  module Helpers
    def authorize_user!(headers)
      authorize_user(headers) ? true : error!('403 Forbidden', 403)
    end

    def authenticate_user!(params)
      authenticate_user(params) ? true : error!('401 Unauthorized', 401)
    end

  private
    #monkeypatch these 2 methods if you want to provide custom authentication/authorization
    def authorize_user(headers)
      token, options = AuthorizationHeader.token_and_options(headers)

      user_email = options.blank?? nil : options[:email]

      correct_email = user_email == Rack::Reqorder.configuration.auth_email
      correct_token = token == user_email_password_md5

      return (correct_email && correct_token) ? true : false
    end


    def authenticate_user(params)
      email = params.user.email
      password = params.user.password

      correct_email = email == Rack::Reqorder.configuration.auth_email
      correct_password = password == Rack::Reqorder.configuration.auth_password

      return (correct_email && correct_password)? true : false
    end

    def user_email_password_md5(user: nil)
      #if user.nil?
      Digest::MD5.hexdigest(
        Rack::Reqorder.configuration.auth_email +
        Rack::Reqorder.configuration.auth_password
      )
      #else
      #end
    end
    #taken from rails ActionController::HttpAuthentication::Token ^_^
    class AuthorizationHeader
      class << self
        TOKEN_KEY = 'token='
        TOKEN_REGEX = /^(Token|Bearer) /
        AUTHN_PAIR_DELIMITERS = /(?:,|;|\t+)/

        def token_and_options(headers)
          authorization_request = headers['Authorization']

          if authorization_request[TOKEN_REGEX]
            params = token_params_from authorization_request
            [params.shift[1], Hash[params].with_indifferent_access]
          end
        end

      private

        def token_params_from(auth)
          rewrite_param_values params_array_from raw_params auth
        end

        # Takes raw_params and turns it into an array of parameters
        def params_array_from(raw_params)
          raw_params.map { |param| param.split %r/=(.+)?/ }
        end

        # This removes the <tt>"</tt> characters wrapping the value.
        def rewrite_param_values(array_params)
          array_params.each { |param| (param[1] || "").gsub! %r/^"|"$/, '' }
        end

        # This method takes an authorization body and splits up the key-value
        # pairs by the standardized <tt>:</tt>, <tt>;</tt>, or <tt>\t</tt>
        # delimiters defined in +AUTHN_PAIR_DELIMITERS+.
        def raw_params(auth)
          _raw_params = auth.sub(TOKEN_REGEX, '').split(/\s*#{AUTHN_PAIR_DELIMITERS}\s*/)

          if !(_raw_params.first =~ %r{\A#{TOKEN_KEY}})
            _raw_params[0] = "#{TOKEN_KEY}#{_raw_params.first}"
          end

          _raw_params
        end
      end
    end
  end
end

