Recaptcha.configure do |config|
  config.site_key  = ENV['RECAPTCHA_CLIENT']
  config.secret_key = ENV['RECAPTCHA_SERVER']
end
