User.destroy_all
User.create!(name:  "Example User",
  email: "example@railstutorial.org",
  password: "foobar",
  password_confirmation: "foobar",
  date_of_birth: "1995-03-29",
  is_admin: true,
  status: 0,
  activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  date_of_birth = "1970-01-01"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password,
    date_of_birth: date_of_birth,
    status: 0,
    activated_at: Time.zone.now)
end

users = User.order(:created_at).take 6
50.times do
  content = Faker::Lorem.sentence 5
  users.each { |user| user.microposts.create!(content: content) }
end

users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
