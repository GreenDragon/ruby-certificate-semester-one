class VendingMachine
  
  # Must be able to:
  #
  # * Hold multiple products with differing prices.
  # * Know when it is out of a specific product.
  # * Refill specific products.
  # * Sell specific products (and therefor deal with user input and payments)
  
  # has many products
  @@products = {}
  
  # products have different prices
  @@prices = {}
  
  attr_accessor :product, :count, :price, :cash, :change
  
  def initialize ()
    @@products = {}
    @@prices = {}
  end
  
  def products ()
    [ @@products ]
  end
  
  def new_product(product, count, price)
    if @@products.key?(product) then
      "Product: #{product} already exists!"
    else
      @@products[product] = count
      @@prices[product] = price
      [ "#{product}", count, price ]
    end
  end
  
  def dispense(product,count)
    if @@products.key?(product) then
      @count = @@products[product]
      if ( @count - count ) >= 0 then
        @@products[product] -= count
      else
        "Not enough product: #{product}, current count: @count"
      end
    else
      "Product: #{product} not found!"
    end
  end
  
  def refill(product,count)
    if @@products.key?(product) then
      @@products[product] += count
    else
      "Product: #{product} not found!"
    end
  end
  
  def purchase(product, amount, cash)
    if @@products.key?(product) then
      @count = @@products[product]
      @price = @@prices[product]
      if ( @count - amount ) >= 0 then
        @change = cash - ( @price * amount )
        if @change >= 0 then
          @@products[product] -= amount
          [ "#{product}", amount, @change ]
        else
          [ "Short Funds", 0, @change]
        end
      else
        if @count == 0 then
          [ "#{product} out of stock!", 0, cash ]
        else
          [ "Not enough #{product}!", 0, cash ]
        end
      end
    else
      "Product: #{product} not found!"
    end
  end
           
  
end
