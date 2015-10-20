class CreditLine

	# A class to represent a credit line

	# limit: total credit limit
	# apr: decimal value, e.g. 0.35 representing APR	
	def initialize(limit, apr)
		@limit = limit
		@apr = apr
		@principal_balance = 0
		@transactions = []
		@interest = 0.0
	end
		
	# returns available funds for this line
	def available
		@limit - @principal_balance
	end

	# withdraws as much of amount as is available, and logs transaction
	def withdraw(amount)
		amount = available if amount > available
		@principal_balance += amount
		new_transaction = { :type => "withdrawal", :amount => amount, :time => Time.now }
		@transactions << new_transaction
		return amount
	end	

	# makes a payment of amount and logs transaction
	def make_payment(amount)
		@principal_balance -= amount
		new_transaction = { :type => "payment", :amount => amount, :time => Time.now }
		@transactions << new_transaction
	end

	# This is called once a day
	# Interest accumulates every day, based on the size of the current principal balance
	def update_interest
		@interest += (@apr.to_f / 365) * @principal_balance
	end

	# Calculates the total payment due for the month
	# and resets the monthly interest value to 0
	def bill
		rounded = ((@principal_balance + @interest) * 100).round / 100.0
		@interest = 0.0
		return "Total payment due: $%.2f" % rounded
	end
	
	# Returns a log of all transactions for this line
	def history
		h = "Transaction History\\n"
		@transactions.each do |t|
			h += "#{t[:time]}: #{t[:type]} of #{t[:amount]}\\n"
		end
		return h
	end

	def to_string
		rounded = (@interest * 100).round / 100.0
		"CreditLine: Limit = #{@limit}, APR = #{@apr}, Month's interest = %.2f" % rounded
	end
end
