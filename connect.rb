require 'tiny_tds'
@client = TinyTds::Client.new username: 'sa', password: 'SApassword!',
    host: 'localhost', port: 1433
puts 'Connecting to SQL Server'

if @client.active? == true then puts 'Done' end

@client.close