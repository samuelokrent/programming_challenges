require 'socket'
require_relative 'CreditLine.rb'

# CreditLineServer runs on port 7777
cl_server = TCPServer.new("127.0.0.1", 7777)

# Array of all credit lines that have been created
credit_lines = []

loop do
	# Allow for multiple client connections
	Thread.start(cl_server.accept) do |client|
		client.puts "Connected. Enter 'h' for help"
		
		# Continually accept client input
		while input = client.gets
			inputs = input.split(" ")
			case inputs.first

			# Determine which command has been entered
			when "n"
				# Create a new CreditLine object with given parameters
				if inputs.length != 3
					client.puts "help"
				else
					limit = inputs[1].to_i
					apr = inputs[2].to_f
					credit_lines << CreditLine.new(limit, apr)
					client.puts "Created #{credit_lines.last.to_string}"
				end

			when "p"
				if inputs.length == 1
					# Respond with indexed list of all CreditLines
					output = ""
					credit_lines.length.times do |n|
						output += "#{n}: #{credit_lines[n].to_string}\\n"
					end
					client.puts output
				else
					# Respond with specified CreditLine and its transaction history
					idx = inputs[1].to_i
					# Make sure idx is within bounds
					idx = credit_lines.length - 1 if idx >= credit_lines.length
					client.puts "#{idx}: #{credit_lines[idx].to_string}\\n#{credit_lines[idx].history}"
				end

			when "w"
				if inputs.length != 3
					client.puts "help"
				else
					# Make withdrawal from specified CreditLine
					idx = inputs[1].to_i
					amount = inputs[2].to_f
					client.puts "Withdrawing #{credit_lines[idx].withdraw(amount)} from Credit Line #{idx}\\n" +
					"Available Funds: #{credit_lines[idx].available}"
				end

			when "mp"
				if inputs.length != 3
					client.puts "help"
				else
					# Make payment for specified CreditLine
					idx = inputs[1].to_i
					amount = inputs[2].to_f
					credit_lines[idx].make_payment(amount)
					client.puts "Made Payment of #{amount} on Credit Line #{idx}\\n" +
					"Available Funds: #{credit_lines[idx].available}"
				end

			when "update_interest"
				# Update interest for all CreditLines
				credit_lines.each do |cl|
					cl.update_interest
				end
				client.puts "Updated interest"

			when "bill"
				# Bill all credit lines, and respond with list of bills
				output = ""
				credit_lines.length.times do |n|
					output += "#{n}: #{credit_lines[n].bill}\\n"
				end
				client.puts "Billed credit lines\\n" + output

			else
				# User has entered 'h' or invalid command
				client.puts "help"
			end
		end
	end
end
