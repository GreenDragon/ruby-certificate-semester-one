class Bank
  
  # Must be able to:
  #
  # * Make new accounts.
  # * Close accounts.
  # * Make deposits for a specific account.
  # * Make withdrawls for a specific account.
  
  # has many accounts
  @@accounts = {}
  
  attr_accessor :account_name, :account_balance
  
  def initialize ()
    @@accounts = {}
  end
    
  def new_account(name, amount)
    @account_name = name
    @account_balance = amount
    if @@accounts.has_key?(name)
      "Account: #{name} exists!"
    else
      @@accounts[name] = amount
      [ "#{name}", @@accounts[name] ]
    end
  end

  def deposit(account, amount)
    if @@accounts.has_key?(account) then
      @account_balance = @@accounts[account]
      @account_balance += amount
      @account_balance
    else
      "Account: #{account} not found"
    end
  end
  
  def withdraw(account, amount)
    if @@accounts.has_key?(account) then
      @account_balance = @@accounts[account]
      if ( @account_balance - amount ) > 0
        @@accounts[account] -= amount
      else
        "Insufficient Funds"
      end
    else
      "Account: #{account} not found"
    end
  end
  
end
