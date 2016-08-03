class EmailValidator
  class << self
    # Return true if email is a valid "@change.com" email address, and false otherwise
    def validate(email)
      email.scan(/\b[A-Z0-9._%a-z\-]+@change\.com\z/).any?
    end
  end
end
