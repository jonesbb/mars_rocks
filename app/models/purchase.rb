class Purchase < ActiveRecord::Base
  attr_accessible :email, :name, :amount, :quantity, :stripe_card_token
  
  attr_accessor :stripe_card_token
  
  def save_with_payment
    if valid?
      logger.debug "DEBUG: Quantity is: #{self.quantity}"
      self.amount = 50
      logger.debug "DEBUG: amount is: #{amount}"
      customer = Stripe::Charge.create(amount: amount, currency: "usd", card: stripe_card_token, description: email)
      self.stripe_customer_token = customer.id
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

end
