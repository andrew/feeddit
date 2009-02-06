# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_feeddit_session',
  :secret      => 'fc2d2beaf0fc0c4c3edf102e15ab0586fb24acdf89e4eb61765ed513bc2fba1eff706f8dcb9a9092f30137610b55004655a4a9626fb56b101aafbdbffa0a7400'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
