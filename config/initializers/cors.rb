# Rails.application.config.action_dispatch.cookies_same_site_protection = :none if Rails.env === "production"
# Rails.application.config.action_controller.forgery_protection_origin_check = false

Rails.application.config.middleware.insert_before 0, Rack::Cors do

    allow do
        origins "http://localhost:3001"
        resource "*", headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head],
        expose: ['Total'],
        credentials: true
    end

    allow do
        origins "https://meteor-erp-app.herokuapp.com"
        resource "*", headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head],
        expose: ['Total'],
        credentials: true
    end
end