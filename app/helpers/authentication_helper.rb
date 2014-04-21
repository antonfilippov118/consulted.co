require 'digest/sha2'
module AuthenticationHelper
  #
  # TODO: remove this once the project goes live
  # There is an exception for the twilio calls (handle and lookup)
  #
  USERS  = { ENV['USER'] => ENV['PASSWORD'] }
  SECRET = Digest::SHA2.digest "#{ENV['USER']}#{ENV['PASSWORD']}"
  def authenticate!

    value = cookies[:consulted_secret]
    if value == SECRET
      return true
    else
      authenticated = authenticated = authenticate_or_request_with_http_digest('Consulted.co Platform beta') do |name|
        USERS[name]
      end

      return false unless authenticated
      cookies[:consulted_secret] = SECRET
      true
    end
  end

end
