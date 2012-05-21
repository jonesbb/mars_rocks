class Purchase < ActiveRecord::Base
  attr_accessible :email, :name, :cost, :quantity, :stripe_card_token
  
  attr_accessor :stripe_card_token
  
  def save_with_payment
    if valid?
      # cost is 50 cents/lb calculated here
      self.cost = 50 * quantity
      logger.debug "DEBUG: amount is: #{cost}"
      customer = Stripe::Charge.create(amount: cost, currency: "usd", card: stripe_card_token, description: email)
      #self.stripe_customer_token = customer.id
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

end
