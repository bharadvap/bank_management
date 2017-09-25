class Transaction < ApplicationRecord
  #
  ## Associations
  #
  belongs_to :account

  #
  ## Validations
  #
  validates(
    :description,
    presence: true,
  )
  validates(
    :amount,
    presence: true,
  )
  validates(
    :transaction_type,
    presence: true
  )

  #
  ## Callbacks
  #
  before_validation :check_account_number
  after_create :remove_amount_from_balance
  def check_account_number
    if self.transaction_type == "NEFT"
      @account = Account.find_by(account_number: self.account_number)
      if !@account.present?
        errors.add(:account_number,"Account is not Exists")
      end
    end
  end

  def remove_amount_from_balance
    if self.transaction_type == "NEFT"
      @account = Account.find_by(account_number: self.account_number)
      self.account.update(balance: self.account.balance - self.amount)
      @account.balance = @account.balance + self.amount
    elsif self.transaction_type == "Withdraw"
      @account = self.account
      @account.balance = @account.balance - self.amount
    end
    @account.save
  end
end
