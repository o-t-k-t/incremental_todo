100.times do
  Task.create(name: Faker::Dune.title, description: Faker::Dune.quote)
end
