100.times do
  Task.create(
    name: Faker::Lorem.sentence(3, true, 3),
    description: Faker::Lorem.sentence(3, true, 20)
  )
end
