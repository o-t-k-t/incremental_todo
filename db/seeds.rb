MAX_PHASES = 5

puts "1 / #{MAX_PHASES} Register a initial administorator"
user = User.create!(
  name: 'fist_administor',
  email: ENV['FISRT_ADMIN_EMAIL'],
  password: ENV['FISRT_ADMIN_PASSWORD'],
  password_confirmation: ENV['FISRT_ADMIN_PASSWORD'],
  admin: true
)

puts "2 / #{MAX_PHASES} Register initial labels"
house_lable = Label.create!(name: '家事',
                            description: '🍳買い物や、掃除など登録しましょう',
                            color: :blue)
investifatoin_label = Label.create!(name: '調べもの',
                                    description: 'わからないことがあったら忘れずに登録しましょう🌱',
                                    color: :yellow)

puts "3 / #{MAX_PHASES} Regsiter seed users and groups"
groups = []
users = []

150.times do |i|
  password = Faker::Internet.password

  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password,
    admin: false
  )
  users << user

  next unless (i % 10).zero?

  name = Faker::ProgrammingLanguage.name
  g = Group.new(name: "#{name}勉強中", description: "#{name}を勉強する人が集まるグループです。")
  Membership.create_with_group!(user, g)
  groups << g
end

puts "4 / #{MAX_PHASES} Associate users with group"
users.select { |u| u.groups.empty? }.each do |u|
  Membership.create!(user: u, group: groups.sample, role: :general)
end

puts "5 / #{MAX_PHASES} Tasks"
User.all.each do |u|
  rand(0..20).times do |j|
    name = Faker::ProgrammingLanguage.name

    task = u.tasks.create!(
      name: name,
      description: ["#{name}について調べる", "#{name}でCLIツールを作る", "#{name}のOSSアプリを探して読む", "#{name}の勉強会を探す"].sample,
      priority: rand(1..3),
      deadline: Time.zone.now + (20 + j).days
    )
    task.put_label(investifatoin_label.id)

    name = %w[夕飯の買い物 家賃の振込 給与振込口座の変更 旅行の予約].sample
    task = u.tasks.create!(
      name: name,
      description: "#{name}をとにかくやる!",
      priority: rand(1..3),
      deadline: Time.zone.now + (20 + j).days
    )
    task.put_label(house_lable.id)
  end
end
