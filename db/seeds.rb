50.times do |_i|
  password = Faker::Internet.password(6, 20, true, true)

  user = User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password
  )

  rand(0..20).times do |i|
    user.tasks.create(
      name: Faker::Lorem.sentence(3, true, 3),
      description: Faker::Lorem.sentence(3, true, 20),
      priority: rand(1..3),
      deadline: DateTime.current + i
    )
  end
end
