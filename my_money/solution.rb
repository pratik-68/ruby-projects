class MyMoneySolution
  COMMANDS = {
    ALLOCATE: 'ALLOCATE',
    SIP: 'SIP',
    CHANGE: 'CHANGE',
    BALANCE: 'BALANCE',
    REBALANCE: 'REBALANCE'
  }
  MONTH_HASH = {
    JANUARY: 1,
    FEBRUARY: 2,
    MARCH: 3,
    APRIL: 4,
    MAY: 5,
    JUNE: 6,
    JULY: 7,
    AUGUST: 8,
    SEPTEMBER: 9,
    OCTOBER: 10,
    NOVEMBER: 11,
    DECEMBER: 12
  }

  # Initialize
  #
  # @param {String} initial_allocation
  def initialize(initial_allocation)
    allocation_list = initial_allocation.split
    equity = allocation_list[1]
    debt = allocation_list[2]
    gold = allocation_list[3]

    @funds = {}
    @funds['JANUARY'] = {
      equity: equity,
      debt: debt,
      gold: gold
    }
    @rate = calculate_rate(@funds['JANUARY'])
    @sip = nil
  end

  # Manage each call
  #
  # @param {String} input
  def call(input)
    input_string = input.split
    input_command = input_string[0]

    case input_command
    when COMMANDS[:SIP]
      sip(input_string[1], input_string[2], input_string[3])
    when COMMANDS[:CHANGE]
      rate_change(input_string[1], input_string[2], input_string[3], input_string[4])
    when COMMANDS[:BALANCE]
      balance(input_string[1])
    when COMMANDS[:REBALANCE]
      rebalance_amount
    end
  end

  # Initialize the sip
  #
  # @param {String} equity
  # @param {String} debt
  # @param {String} gold
  # @return {void}
  def sip(equity, debt, gold)
    @sip = {
      equity: equity,
      debt: debt,
      gold: gold
    }
  end

  # Recalculate the amount for the month based on the changed rate and sip
  #
  # @param {String} equity
  # @param {String} debt
  # @param {String} gold
  # @param {String} month_name
  # @return {void}
  def rate_change(equity, debt, gold, month_name)
    add_sip(month_name)
    add_market_change(equity, debt, gold, month_name)
    rebalance(month_name)
  end

  # Return the balance amount for the month
  #
  # @param {String} month_name
  # @return {void}
  def balance(month_name)
    amount_hash = @funds[month_name]
    print_amount(amount_hash)
  end

  # Return the rebalance amount
  #
  # @prints {String}
  def rebalance_amount
    if @rebalance_amount != nil
      print_amount(@rebalance_amount)
    else
      print 'CANNOT_REBALANCE'
    end
  end

  # Add the sip to the monthly balance
  #
  # @param {String} month_name
  # @return {void}
  def add_sip(month_name)
    return if @funds[month_name] != nil

    @funds[month_name] = previous_funds(month_name)
    @funds[month_name].each do |key, _|
      @funds[month_name][key] = @sip[key].to_i + @funds[month_name][key].to_i
    end
  end

  # Add the market change balance to the monthly balance
  #
  # @param {String} equity
  # @param {String} debt
  # @param {String} gold
  # @param {String} month_name
  # @return {void}
  def add_market_change(equity, debt, gold, month_name)
    @funds[month_name][:equity] = @funds[month_name][:equity].to_i + calculate_amount_from_rate(@funds[month_name][:equity], equity)
    @funds[month_name][:debt] = @funds[month_name][:debt].to_i + calculate_amount_from_rate(@funds[month_name][:debt], debt)
    @funds[month_name][:gold] = @funds[month_name][:gold].to_i + calculate_amount_from_rate(@funds[month_name][:gold], gold)
  end

  # Calculate amount from the given rate
  #
  # @param {String} amount
  # @param {String} rate
  # @return {Integer}
  def calculate_amount_from_rate(amount, rate)
    to_nearest_i(amount.to_i * rate.to_f * 0.01)
  end

  # Print the amount
  #
  # @param {Hash} amount_hash
  # @prints {String}
  def print_amount(amount_hash)
    print amount_hash[:equity], ' ', amount_hash[:debt], ' ', amount_hash[:gold], "\n"
  end

  # Rebalance the amount if required
  #
  # @param {String} month_name
  # @return {Hash}
  def rebalance(month_name)
    return unless %w[JUNE DECEMBER].include?(month_name)

    total_amount = 0
    @funds[month_name].each { |_, value| total_amount += value.to_i }

    @rebalance_amount = {
      equity: calculate_amount_from_rate(total_amount, @rate[:equity]),
      debt: calculate_amount_from_rate(total_amount, @rate[:debt]),
      gold: calculate_amount_from_rate(total_amount, @rate[:gold])
    }
    @funds[month_name] = {
      equity: @rebalance_amount[:equity],
      debt: @rebalance_amount[:debt],
      gold: @rebalance_amount[:gold]
    }
  end

  # Calculate the rate of each fund type
  #
  # @param {Hash} funds
  # @return {Hash}
  def calculate_rate(funds)
    total_amount = 0

    funds.each { |_, value| total_amount += value.to_i }

    {
      equity: ((funds[:equity].to_f * 100) / total_amount).round(2),
      debt: ((funds[:debt].to_f * 100) / total_amount).round(2),
      gold: ((funds[:gold].to_f * 100) / total_amount).round(2)
    }
  end

  # Return the funds of the last month
  #
  # @param {String} month_name
  # @return {Hash}
  def previous_funds(month_name)
    prev_month_number = month_to_number(month_name) - 1
    prev_month_name = month_from_number(prev_month_number)

    temp = @funds[prev_month_name]
    {
        equity: temp[:equity],
        debt: temp[:debt],
        gold: temp[:gold]
    }
  end

  # Return month number from month name
  #
  # @param {String} month_name
  # @return {Integer}
  def month_to_number(month_name)
    MONTH_HASH[month_name.to_sym]
  end

  # Return month name from month number
  #
  # @param {Integer} month_number
  # @return {String}
  def month_from_number(month_number)
    MONTH_HASH.invert[month_number].to_s
  end

  # Return nearest integer value
  #
  # @param {Float} value
  # @return {Integer}
  def to_nearest_i(value)
    value.to_f.floor
  end
end

# Main Function
def main
  # Input 1
  input_file_path = 'input1.txt'
  input_file = File.readlines(input_file_path)

  # Allocate
  solution = MyMoneySolution.new(input_file[0])

  puts "Output 1:"
  # Process
  input_file[1..-1].each do |input|
    solution.call(input)
  end

  # Input 2
  input_file_path = 'input2.txt'
  input_file = File.readlines(input_file_path)

  # Allocate
  solution = MyMoneySolution.new(input_file[0])

  puts
  puts "Output 2:"
  # Process
  input_file[1..-1].each do |input|
    solution.call(input)
  end
  puts
end

main
