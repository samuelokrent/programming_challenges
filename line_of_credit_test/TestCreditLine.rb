require_relative './CreditLine.rb'

cl = CreditLine.new(1000, 0.35)

cl.withdraw(500)
15.times do 
	cl.update_interest 
end
cl.make_payment(200)
10.times do 
	cl.update_interest
end
cl.withdraw(100)
5.times do 
	cl.update_interest 
end

cl.bill
cl.print_history

puts "Available: #{cl.withdraw(650)}"
