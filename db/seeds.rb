puts "Seeding The Long Road Club…"

members = [
  { name: "Aarav Menon", username: "aarav_drives", email: "aarav@example.com", location: "Bengaluru", color: "ochre", bio: "Road-trip obsessive and patient keeper of an old Thar." },
  { name: "Dev Malhotra", username: "dev_m", email: "dev@example.com", location: "New Delhi", color: "green", bio: "Used-car research, European sedans, and extremely detailed spreadsheets." },
  { name: "Mira Shah", username: "mira_miles", email: "mira@example.com", location: "Mumbai", color: "blue", bio: "Hybrid owner, everyday driver, occasional autocrosser." },
  { name: "Kabir Sethi", username: "late_braker", email: "kabir@example.com", location: "Pune", color: "red", bio: "Motorsport tragic. Track-day novice. Always watching the timing screens." },
  { name: "Nikhil Kurian", username: "nikhil_e30", email: "nikhil@example.com", location: "Kochi", color: "green", bio: "Restoring, driving, and documenting an E30 one careful step at a time." }
].map do |attributes|
  user = User.find_or_initialize_by(email: attributes[:email])
  user.assign_attributes(
    name: attributes[:name], username: attributes[:username], location: attributes[:location],
    avatar_color: attributes[:color], bio: attributes[:bio], verified: true
  )
  user.password = user.password_confirmation = "longroad2026" if user.password_digest.blank?
  user.save!
  user
end

categories = [
  [ "Ownership", "blue", "Long-term reports and the reality of living with a car." ],
  [ "Road Trips", "ochre", "Great roads, useful itineraries, and stories from the journey." ],
  [ "Buying Advice", "green", "Thoughtful help choosing new and used cars." ],
  [ "Motorsport", "red", "Racing, track days, autocross, and everything timed." ],
  [ "Classics", "ochre", "Preservation, restoration, and old-car appreciation." ],
  [ "DIY & Care", "green", "Maintenance, detailing, tools, and garage knowledge." ]
].each_with_index.to_h do |(name, color, description), position|
  category = Category.find_or_initialize_by(slug: name.parameterize)
  category.update!(name: name, color: color, description: description, position: position)
  [ name, category ]
end

discussion_data = [
  {
    user: members[0], category: categories["Road Trips"],
    title: "Chasing the monsoon through the Western Ghats",
    body: "Four days, three hill stations, one very happy old Thar—and all the chai stops worth saving.\n\nWe began before sunrise in Bengaluru, took the quieter roads through Hassan, and reached the first wall of rain just beyond Sakleshpur. This thread has the route, fuel stops, road conditions, and the small homestays that made the trip memorable.",
    views: 12_430, featured: true, replies: [
      [ members[2], "This is exactly the level of detail a useful travelogue needs. How was the Shiradi section in heavy rain?", nil ],
      [ members[0], "Slow but manageable. The repaired stretches were good; visibility was the bigger issue after 4 pm.", 0 ]
    ]
  },
  {
    user: members[1], category: categories["Buying Advice"],
    title: "The sensible enthusiast’s guide to a used Octavia vRS",
    body: "What to inspect, which years to chase, and what the service bills actually look like.\n\nI spoke with six owners, two independent specialists, and one person who has now bought the same generation twice. The short version: buy on condition, keep a serious maintenance reserve, and never skip the cooling-system inspection.",
    views: 18_810, replies: [ [ members[3], "The cooling-system note cannot be overstated. I would add a scan for intermittent faults before paying a deposit.", nil ] ]
  },
  {
    user: members[2], category: categories["Ownership"],
    title: "20,000 km with my Honda City e:HEV",
    body: "Quiet competence, remarkable economy, and the little things nobody mentions in reviews.\n\nMost of those kilometres were an even split between Mumbai traffic and highway runs. The drivetrain remains the highlight, but the ownership story is more nuanced once tyres, boot space, and highway refinement enter the picture.",
    views: 9_140, replies: [ [ members[1], "What has your real tank-to-tank efficiency been over the last three fills?", nil ] ]
  },
  {
    user: members[3], category: categories["Motorsport"],
    title: "Why this F1 season suddenly feels wide open",
    body: "A closer look at the upgrades, tyre calls, and midfield surprises changing the order.\n\nThe headline results only tell part of the story. The most interesting shift is in long-run degradation, where three teams now seem capable of forcing genuinely different strategies on Sunday.",
    views: 24_620, featured: true, replies: [ [ members[0], "The tyre offset has made the final stint worth watching again. Long may it continue.", nil ] ]
  }
]

discussion_data.each do |data|
  discussion = Discussion.find_or_initialize_by(title: data[:title])
  discussion.assign_attributes(user: data[:user], category: data[:category], body: data[:body], featured: data[:featured] || false)
  discussion.save!
  discussion.update_columns(views_count: data[:views], last_posted_at: [ discussion.last_posted_at, 2.hours.ago ].compact.max)
  created_posts = []
  data[:replies].each do |author, body, parent_index|
    post = discussion.posts.find_or_create_by!(user: author, body: body)
    post.update!(parent: parent_index.nil? ? nil : created_posts.fetch(parent_index))
    created_posts << post
  end
end

def next_occurrence(month, day, hour)
  candidate = Time.zone.local(Time.current.year, month, day, hour)
  candidate.future? ? candidate : candidate.next_year
end

events = [
  { title: "Sunday Dawn Drive", location: "Nandi Hills, Bengaluru", starts_at: next_occurrence(8, 24, 5), capacity: 60, description: "A gentle sunrise run out of Bengaluru, followed by breakfast and an unhurried parking-lot catch-up. This is a road drive, not a speed event; good manners and safe gaps are part of the route." },
  { title: "Classics & Coffee", location: "BKC, Mumbai", starts_at: next_occurrence(9, 7, 7), capacity: 90, description: "A relaxed Sunday gathering for classic cars, modern classics, and the people who keep them going. Spectators and curious future owners are very welcome." }
].map do |attributes|
  event = Event.find_or_initialize_by(title: attributes[:title])
  event.update!(attributes.merge(ends_at: attributes[:starts_at] + 4.hours, published: true))
  event
end

events.each do |event|
  members.first(3).each { |member| EventRsvp.find_or_create_by!(event: event, user: member) }
end

garage = GarageFeature.find_or_initialize_by(owner_name: "Nikhil Kurian", car_year: 1986, car_make: "BMW", car_model: "E30")
garage.update!(
  user: members[4], city: "Kochi", title: "Built slowly, driven properly.", featured: true,
  summary: "Nikhil’s decade-long restoration is full of patience, period-correct details, and one very special story.",
  story: "The car arrived as a tired but fundamentally honest shell. Nikhil’s first decision was also the most important: there would be no deadline.\n\nMechanical reliability came before paint. Every bush, hose, seal, and tired connector was inspected before the bodywork began. The result is not a museum piece. It is a car that starts on humid mornings, handles long coastal drives, and wears the small marks of regular use with pride.\n\nThe restoration took nearly ten years, but the real achievement is that the E30 now gets driven exactly as its makers intended.",
  published_at: 1.week.ago
)

guide_data = [
  [ members[1], "How to inspect a used car", "Buying guide", 12, "A calm, repeatable inspection process that helps you look past shiny paint and a persuasive seller.", "Begin before you see the car. Ask for service records, registration details, insurance history, and cold-start access. A seller’s willingness to share these is information in itself.\n\nAt the car, work methodically from documents to body, cabin, engine bay, underbody, and road test. Photograph findings and resist negotiating until you understand the full pattern.\n\nNo used car is perfect. The goal is to distinguish ordinary wear from neglect, accident damage, and expensive deferred maintenance." ],
  [ members[3], "Your first track day, decoded", "Motorsport", 9, "What to bring, how to prepare, and why outright speed is not the point of your first day on circuit.", "A first track day should be about observation, consistency, and bringing the car home in the same condition it arrived. Check fluids, pads, tyres, wheel torque, and recovery points well before the event.\n\nUse the opening sessions to learn flags, braking references, and traffic. Leave the stopwatch alone. Smooth inputs and awareness will make you faster later; chasing a lap time immediately usually makes learning slower." ],
  [ members[4], "The weekend detailing ritual", "DIY & care", 7, "A satisfying maintenance wash that protects the car without consuming the entire Sunday.", "Work in shade and begin with the wheels. A thorough rinse and sensible pre-wash remove the dirt most likely to mark the paint. Use separate tools for wheels and bodywork.\n\nDry with clean microfibre towels and finish by checking tyre pressures, fluid levels, wiper condition, and new stone chips. Detailing is at its best when it doubles as inspection." ]
]

guide_data.each do |author, title, section, minutes, summary, body|
  guide = Guide.find_or_initialize_by(title: title)
  guide.update!(user: author, section: section, read_time_minutes: minutes, summary: summary, body: body, published_at: 2.days.ago)
end

puts "Seeded #{User.count} members, #{Discussion.count} discussions, #{Event.count} events, #{GarageFeature.count} garage feature, and #{Guide.count} guides."
