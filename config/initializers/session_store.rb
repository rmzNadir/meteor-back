if Rails.env === "production"
    Rails.application.config.session_store :cookie_store, key: "_meteor",
    domain: 'meteor-erp-app.herokuapp.com'
    # secure: true,
    # httponly: false,
    # same_site: :none
else
    Rails.application.config.session_store :cookie_store, key: "_meteor"
end
