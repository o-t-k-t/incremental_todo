user = User.create!(
  name: 'fist_administor',
  email: ENV['FISRT_ADMIN_EMAIL'],
  password: ENV['FISRT_ADMIN_PASSWORD'],
  password_confirmation: ENV['FISRT_ADMIN_PASSWORD'],
  admin: true
)

house_lable = Label.create!(name: '家事',
                            description: '🍳買い物や、掃除など登録しましょう',
                            color: :blue)
investifatoin_label = Label.create!(name: '調べもの',
                                    description: 'わからないことがあったら忘れずに登録しましょう🌱',
                                    color: :yellow)

150.times do |_i|
  password = Faker::Internet.password

  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password,
    admin: false
  )

  rand(0..20).times do |_i|
    task = user.tasks.create!(
      name: Faker::Lorem.sentence(3, true, 3),
      description: Faker::Lorem.sentence(3, true, 20),
      priority: rand(1..3),
      deadline: Time.zone.now + 20 + j
    )
    task.put_label(house_lable)
    task.put_label(investifatoin_label)
  end
end
