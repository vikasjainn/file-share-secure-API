class JsonWebToken
    # This line retrieves the secret key base from Rails application secrets and converts it to a string.
    SECRET_KEY = Rails.application.credentials.secret_key_base.to_s


    # This method takes a payload (typically containing user information) and an optional expiration time.
    def self.encode(payload, exp = 24.hours.from_now)
        # Set the expiration time for the token (default is 24 hours from now)
        payload[:exp] = exp.to_i
        
        # Encode the payload into a JWT token
        JWT.encode(payload, SECRET_KEY)
    end

    def self.decode(token)
        decoded = JWT.decode(token, SECRET_KEY)[0]

        # Class provided by ActiveSupport. 
        # It extends the behavior of regular Hash by allowing string and symbol keys to be used interchangeably.
        HashWithIndifferentAccess.new decoded
    end
end