total_population = AgencyPopulation.sum(:population)
total_bookings = @bookings.count

json.total_population total_population
json.total_bookings total_bookings

json.agencies @agencies.each do |agency|
  json.name agency['extdesc']

  bookings_count = @bookings.where(arrest: agency['slc_id']).count
  json.bookings_count bookings_count
  json.bookings_pct ((bookings_count.to_f / total_bookings)*100).round(1)

  population_count = AgencyPopulation.find_by(agency_id: agency['slc_id']).try(:population) || 0
  json.population_count population_count
  json.population_pct ((population_count.to_f / total_population)*100).round(1)
end.concat([{
  # bookings that are missing agency associations
  name: 'Other (Unknown) Agencies',
  bookings_count: @bookings.where(arrest: '').count,
  bookings_pct: ((@bookings.where(arrest: '').count.to_f / total_bookings)*100).round(1),
  population_count: 0,
  population_pct: 0.0
}])
