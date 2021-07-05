if Rails.env === "production"
    Rails.application.config.session_store :cookie_store, key: "_meteor", domain: "meteor-api.herokuapp.com"
else
    Rails.application.config.session_store :cookie_store, key: "_meteor"
end
