100.times do |i|
  Task.create(
    name: Faker::Lorem.sentence(3, true, 3),
    description: Faker::Lorem.sentence(3, true, 20),
    deadline: DateTime.current + i
  )
end
