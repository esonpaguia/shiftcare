require 'json'

# Load the clients from the JSON file
def load_clients
  file = File.read('clients.json')
  JSON.parse(file)
end

# Command 1: Search clients by name
def search_clients(query)
  clients = load_clients
  matches = clients.select { |client| client["full_name"].downcase.include?(query.downcase) }
  if matches.any?
    matches.each do |client|
      puts "ID: #{client['id']}, Name: #{client['full_name']}, Email: #{client['email']}"
    end
  else
    puts "No clients found matching the query."
  end
end

# Command 2: Find duplicate emails
def find_duplicates
  clients = load_clients
  email_hash = Hash.new { |hash, key| hash[key] = [] }

  clients.each do |client|
    email_hash[client["email"]] << client
  end

  duplicates = email_hash.select { |email, entries| entries.size > 1 }

  if duplicates.any?
    duplicates.each do |email, clients|
      puts "Duplicate email: #{email}"
      clients.each { |client| puts "  ID: #{client['id']}, Name: #{client['full_name']}" }
    end
  else
    puts "No duplicate emails found."
  end
end

# Command-line interface
def main

  command = ARGV[0]
  case command
  when 'search'
    search_clients(ARGV[1])
  when 'duplicates'
    find_duplicates
  else
    puts "Invalid command. Use 'search  <query>' or 'duplicates'."
  end
end

main if __FILE__ == $PROGRAM_NAME
