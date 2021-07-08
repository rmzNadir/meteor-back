if Rails.env === "production"
    Rails.application.config.session_store :cookie_store, key: "_meteor", domain: "https://meteor-erp-app.herokuapp.com"
else
    Rails.application.config.session_store :cookie_store, key: "_meteor"
end
