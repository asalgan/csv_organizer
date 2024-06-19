require 'csv'
require 'set'

CLIENT_DATA  = ['sfid', 'first name', 'last name', 'address', 'city', 'state', 'zip code', 'email', 'mobile phone', 'sms permission'].freeze
VEHICLE_DATA = ['make', 'model', 'year', 'vin', 'mileage', 'sol expires'].freeze

clients = {}
max_vehicle_sets = 1

CSV.foreach('./sol_client_vehicles.csv', headers: true) do |row|
  next if row['sfid'].nil? || row['sfid'].strip.empty?

  client_id    = row['sfid'].downcase.strip
  client_data  = row.to_h.slice(*CLIENT_DATA)
  vehicle_data = row.to_h.slice(*VEHICLE_DATA)

  clients[client_id] ||= { client_data: client_data, vehicles: Set.new }
  clients[client_id][:vehicles] << vehicle_data

  max_vehicle_sets = [clients[client_id][:vehicles].count, max_vehicle_sets].max
end

vehicle_headers = []
max_vehicle_sets.times { |i| VEHICLE_DATA.map{ |vd| vehicle_headers << "#{vd}_#{i+1}" }}
new_headers = CLIENT_DATA + vehicle_headers

CSV.open('sol_client_vehicles_new.csv', 'wb') do |csv|
  csv << new_headers

  clients.each do |sfid, data|
    row = data[:client_data].values
    data[:vehicles].each { |vehicle| row += vehicle.values }
    csv << row
  end
end
