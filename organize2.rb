require 'csv'

rows = CSV.read('./sol_client_vehicles.csv', headers: true)
sfid_groups = rows.group_by { |row| row['sfid'] }
new_data = []
headers = []

sfid_groups.map do |sfid, datas|
  if datas.length == 1
    new_data << datas[0].to_hash
    next
  else
    key_values = Hash.new { |hash, key| hash[key] = [] }
    datas.each do |data_hash|
      data_hash.each do |key, value|
        key_values[key] << value unless key_values[key].include?(value)
      end
    end

    new_data_hash = {}
    current_indices = Hash.new(0)

    datas.each do |data_obj|
      data_obj.each do |key, val|
        if key_values[key].size > 1
          current_indices[key] += 1
          new_key = "#{key}_#{current_indices[key]}"
          new_data_hash[new_key] = val
        else
          new_data_hash[key] = val unless new_data_hash.value?(val)
        end
      end
    end
    headers = new_data_hash.keys if new_data_hash.keys.length > headers.length
    new_data << new_data_hash
  end
end

CSV.open('merged_sol_client_vehicles_2.csv', 'w') do |csv|
  csv << headers
  new_data.each do |row|
    csv << row.values
  end
end
