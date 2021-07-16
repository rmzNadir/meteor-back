if Rails.env === "production"
    Rails.application.config.session_store :cookie_store, key: "_meteor",
    domain: 'meteor-erp-app.herokuapp.com'
    # same_site: :strict
    # secure: true
    # httponly: true,
else
    Rails.application.config.session_store :cookie_store, key: "_meteor"
end
