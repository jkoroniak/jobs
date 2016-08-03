class BusinessReward < ActiveRecord::Base

  belongs_to :business
  has_one :balance

  validates :business_id, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }

  #validates that a Reward Type is only given ONCE to a business
  validates :reward_type, uniqueness: {scope: :business_id, message: ""}

  def save_and_reward
    save && reward
  end

  def save_and_deduct
    save && deduct
  end

  # Business#add_to_balance will increase the balance's amount by whatever is passed in. It will return true if the adjustment succeeds and false otherwise
  def reward
    business.add_to_balance(amount)
  end

  #For a given business reward, administrator want to take away partial or full amount.
  def deduct(amout)
    business.deduct_from_balance(amount)
  end

  # Business#add_message_to_queue pushes a string to a business' notification queue. It will return true if the message is successfully pushed to the queue, and false otherwise.
  def notify_business
    business.add_message_to_queue("Hey #{business.name}, we've just deposited #{amount} into your account! Thanks for being great!")
  end

  def notify_business_about_debit
    business.add_message_to_queue("Hey #{business.name}, we've just deducted #{amount} from your account! Sorry!")
  end

  class << self
    def create_and_administer(business:, amount:, reward_type:)
      entity = new(business: business, amount: amount, reward_type: reward_type)
      if entity.save_and_reward
        entity.notify_business
      end
    end

    def revoke_and_administer(business:, amout:, reward_type:)
      #we can skip this validation here, if we validate in Controller.
      #But assuming that there is no validation at controller level

      # Validate if any reward was given and if given, then we are not taking away more than what this business has.
      # e.g. if this business has 100 points and administrator is trying to take away 120
      if business.business_rewards.blank? || amount > business.balance.amount
        errors.add(:base, "Error: not enough balance points.")
      else
        entity = new(business: business, amount: amount, reward_type: reward_type)
        entity.notify_business_about_debit if entity.save_and_deduct
      end
    end
  end


end
