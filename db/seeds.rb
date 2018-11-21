150.times do |i|
  password = 'llllll'

  user = User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password,
    admin: i < 10
  )

  rand(0..20).times do |j|
    user.tasks.create(
      name: Faker::Lorem.sentence(3, true, 3),
      description: Faker::Lorem.sentence(3, true, 20),
      priority: rand(1..3),
      deadline: DateTime.current + j
    )
  end
end
