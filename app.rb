# file: app.rb

require_relative 'lib/database_connection'

# We need to give the database name to the method `connect`.
DatabaseConnection.connect('social_network')

# Perform a SQL query on the database and get the result set.
sql = 'SELECT id, email, username FROM accounts;'
result = DatabaseConnection.exec_params(sql, [])

# Print out each record from the result set .
result.each do |record|
  p record
end

sql2 = 'SELECT id, title, content, num_of_views FROM posts;'
result2 = DatabaseConnection.exec_params(sql2, [])

result2.each do |record|
  p record
end