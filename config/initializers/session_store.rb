if Rails.env == "production"
  Rails.application.config.session_store :cookie_store, key: '_authentication_key', domain: 'labonneauberge-server.herokuapp.com', secure: true, httponly: false, same_site: :none
else
  Rails.application.config.session_store :cookie_store, key: '_authentication_key'
end