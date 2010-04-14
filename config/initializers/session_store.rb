# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_gp-web-app_session',
  :secret      => 'e0f50d8a1eb07aceac866bdbe6baa5ff0d6df561095f89226c71ea069d3f9455b597142f49a79b151f897a1a1d6a430e7757fb2924bd00fb439e7224d6cc09ba'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
