if Rails.env === "production"
    Rails.application.config.session_store :cookie_store, key: "_meteor",
    domain: '.meteor-erp-api.herokuapp.com'
    # secure: true,
    # httponly: true,
    # same_site: :none
else
    Rails.application.config.session_store :cookie_store, key: "_meteor"
end
