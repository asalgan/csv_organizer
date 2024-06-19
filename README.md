Run `ruby organize.rb` to receive a new csv output, aptly named `sol_client_vehicles_new.csv`. It is written to be flexible to handle any join table records, rather than hard-coding the column names for vehicles. It assumes the column names for the user will be consistent.

Edge cases:
- There may be instances in which the 'sfid' isn't properly formatted. i.e. `abC123`, `abc123`, and ` abc123` would all be different rows in that case. I took care of that by adding `.downcase.strip` to ensure proper matching.
- There may be situations where there is missing data in required fields. This would have to be handled by properly skipping the column rather than having the data shift a column to the left. This can be handled by inserting an empty string value in place of the missing data. This is partially handled via the `next`
- There should be handling of duplicate vehicle data. This is handled via `Set.new`.
- There may be incorrect data types. For example mileage may expect a string but be an integer. The data should be validated/cleaned during processing.
- Missing headers or headers that don't match the hard-coded constants at the top. This code assumes consistently named header data. It can be altered to be more flexible depending on the file used.