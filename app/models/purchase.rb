class Purchase < ActiveRecord::Base
  attr_accessible :email, :name, :cost, :quantity, :stripe_card_token
  
  attr_accessor :stripe_card_token
  
  def save_with_payment
    if valid?
      # cost is 1000 dollars/lb calculated here (input cost to Stripe is in cents)
      self.cost = 100000 * quantity
      self.amount = cost / 100
      logger.debug "DEBUG: cost is: #{cost}"
      logger.debug "DEBUG: amount is: #{amount}"
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
