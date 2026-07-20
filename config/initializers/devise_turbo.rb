# Devise 4.9+ Hotwire integration: validation errors re-render with 422 and
# post-action redirects use 303 so Turbo Drive follows them correctly.
Devise.setup do |config|
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end
