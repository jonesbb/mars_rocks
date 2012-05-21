# if production, use key in heroku
if Rails.env == "production" 
   STRIPE_PUBLIC_KEY = ENV['STRIPE_PUBLIC_KEY']
   Stripe.api_key = ENV['Stripe.api_key']
end
