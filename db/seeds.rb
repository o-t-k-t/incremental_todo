2_000.times do |i|
  Task.create(
    name: Faker::Lorem.sentence(3, true, 3),
    description: Faker::Lorem.sentence(3, true, 20),
    priority: rand(1..3),
    deadline: DateTime.current + i
  )
end
