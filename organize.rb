require 'csv'
require 'set'

CLIENT_DATA  = ['sfid', 'first name', 'last name', 'address', 'city', 'state', 'zip code', 'email', 'mobile phone', 'sms permission'].freeze

clients = {}
max_joined_sets = 1
headers = nil

CSV.foreach('./sol_client_vehicles.csv', headers: true) do |row|
  if headers.nil?
    headers = row.headers
    @joined_table_headers = headers - CLIENT_DATA
  end

  next if row['sfid'].nil? || row['sfid'].strip.empty?

  client_id   = row['sfid'].downcase.strip
  client_data = row.to_h.slice(*CLIENT_DATA)
  joined_data = row.to_h.reject{ |key| CLIENT_DATA.include?(key) }

  clients[client_id] ||= { client_data: client_data, joined_data: Set.new }
  clients[client_id][:joined_data] << joined_data

  max_joined_sets = [clients[client_id][:joined_data].count, max_joined_sets].max
end

additional_headers = []
max_joined_sets.times { |i| @joined_table_headers.map { |vd| additional_headers << "#{vd}_#{i+1}" }}
new_headers = CLIENT_DATA + additional_headers

CSV.open('sol_client_vehicles_new.csv', 'wb') do |csv|
  csv << new_headers

  clients.each do |sfid, data|
    row = data[:client_data].values
    data[:joined_data].each { |data| row += data.values }
    csv << row
  end
end
