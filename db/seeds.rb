# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Create a main sample user.


#Micropost.destroy_all
#User.destroy_all


#Users
User.create!(name:  "Abir",
             email: "abirssc7@gmail.com",
             password:              "abir1234",
             password_confirmation: "abir1234",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

# Generate a bunch of additional users.
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end

# Generate microposts for a subset of users.
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  # image = File.open(Rails.root.join('db/seeds/micropost_placeholder.png'))
  users.each do |user|
    # user.microposts.create!(content: content, image: image)
    micropost = Micropost.new(user: user, content: content)
    micropost.image.attach(
      io: File.open(Rails.root.join('db/seeds/micropost_placeholder.png')), # opening the file inline allows fresh calculation of checksum while uploading to remote storage
      filename: 'micropost_placeholder.png',
      content_type: 'image/png'
    )
    micropost.save!
  end
end



# Create following relationships.
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

