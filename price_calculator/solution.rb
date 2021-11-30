class List
  # Items details available on store.
  #
  # Instruction: Use item name in lower case
  STORE_GENERAL_ITEMS = {
    milk: {
      unit_price: 3.97
    },
    bread: {
      unit_price: 2.17
    },
    banana: {
      unit_price: 0.99
    },
    apple: {
      unit_price: 0.89
    }
  }

  # Items details available on store for sale.
  #
  # Instruction: Use item name in lower case
  STORE_SALE_ITEMS = {
    milk: {
      sale_price: 5.00,
      item_count: 2
    },
    bread: {
      sale_price: 6.00,
      item_count: 3
    }
  }

  # Initialize with instance variables
  def initialize
    @items = Hash.new do |hash, key| 
      hash[key] = {
        quantity: 0,
        cost: 0
      }
    end
    @total_cost = 0
    @total_discount = 0
  end

  # Add item in the purchased list
  #
  # @param {String} name
  def add_item(name)
    requested_item = name.strip.downcase.to_sym

    if STORE_GENERAL_ITEMS[requested_item]
      @items[requested_item][:quantity] += 1 
    else
      puts "Unknown item in the list: #{name}"
    end
  end

  # Calcuate price for the items added in the list
  # 
  # Note: We can use `BigDecimal` for better accuracy
  def calculate_bill
    @items.each do |name, value|
      sale_price_cost = 0
      sale_quantity = 0
      unit_price_cost = 0
      discount = 0

      # Sale price for eligible items
      if STORE_SALE_ITEMS[name]
        eligible_sale_count = value[:quantity] / STORE_SALE_ITEMS[name][:item_count]

        sale_price_cost = eligible_sale_count * STORE_SALE_ITEMS[name][:sale_price]
        sale_quantity += (eligible_sale_count * STORE_SALE_ITEMS[name][:item_count])
      end

      # Unit price for general items or item quantity not eligible for sale
      total_unit_cost = (value[:quantity] - sale_quantity) * STORE_GENERAL_ITEMS[name][:unit_price]

      # Total cost of the item
      value[:cost] = (total_unit_cost + sale_price_cost).round(2)

      # Discount on the item
      discount = (value[:quantity] * STORE_GENERAL_ITEMS[name][:unit_price]) - value[:cost]

      # Update overall total for all the items
      @total_cost += value[:cost]
      @total_discount += discount.round(2)
    end

    @total_cost = @total_cost.round(2)
    @total_discount = @total_discount.round(2)
  end

  # Print the items quantity & price from the list
  def print
    headers = ["Item", "Quantity", "Price"]
    
    print_in_table_form(headers)
    puts "-"*30
    
    @items.each do |k, v|
      print_in_table_form([k.capitalize, v[:quantity], format_amount(v[:cost])])
    end

    puts
    puts "Total price : #{format_amount(@total_cost)}"
    puts "You saved #{format_amount(@total_discount)} today."
  end

  private

    # Return formatted string for amount values
    #
    # @param {Float} amount
    # @return {String}
    def format_amount(amount)
      "$#{sprintf("%.2f", amount)}"
    end

    # Print the values in the table form
    #
    # @param {Array} values
    # @param {Integer} ljust_value
    # @print {String}
    def print_in_table_form(values, ljust_value = 10)
      output = ''
      values.each do |v|
        output += v.to_s.ljust(ljust_value)
      end

      puts output
    end
end

# Main Function
def main
  puts "Please enter all the items purchased separated by a comma"
  input = gets.chomp

  list = List.new
  input.split(',').each { |item| list.add_item(item) }

  list.calculate_bill
  list.print
end

main
