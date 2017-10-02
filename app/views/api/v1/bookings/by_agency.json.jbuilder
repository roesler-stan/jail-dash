total_population = AgencyPopulation.sum(:population)
total_bookings = @bookings.count

json.total_population total_population
json.total_bookings total_bookings

json.agencies @agencies.each do |agency|
  json.name agency['extdesc']

  booking_count = @bookings.where(arrest: agency['slc_id']).count
  json.booking_count booking_count
  json.booking_pct ((booking_count.to_f / total_bookings)*100).round(1)
  
  pop_count = AgencyPopulation.find_by(agency_id: agency['slc_id']).try(:population) || 0
  json.pop_count pop_count
  json.pop_pct ((pop_count.to_f / total_population)*100).round(1)
end
