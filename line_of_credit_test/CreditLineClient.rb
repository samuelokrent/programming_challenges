require 'socket'

def print_help_message
	puts "Options\n" +
	"\t'h' : prints this message\n" +
	"\t'n <limit> <apr>' : creates new credit line\n" +
	"\t'p [index]' : prints all credit lines, or if idx is given, only that credit line\n" +
	"\t'w <id> <amount>' : withdraws amount from credit line with given id\n" +
	"\t'mp <id> <amount>' : makes payment of amount on credit line with given id\n" +
	"\t'update_interest' : updates interest on all credit lines (should be called daily)\n" +
	"\t'bill' : bills all credit lines, and resets interest (should be called every 30 days)\n" +
	"\t'q' : exits from client\n"
end

# Connect to CreditLineServer
socket = TCPSocket.new('127.0.0.1', 7777)

# Continually display server responses, and read user input
while line = socket.gets
	if line == "help\n" 
		# Server has received incorrect input
		# Display helpful usage messsage
		print_help_message 
	else
		# Display server's response
		puts line.gsub(/\\n/, "\n") + "\n"
	end
	
	# Get user input and send to server
	from_client = gets
	break if from_client == "q\n"
	socket.print from_client
end

# Close connection to server
socket.close
