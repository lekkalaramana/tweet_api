user = User.find_by_email(ENV['ADMIN_EMAIL'])
binding.pry
unless user.present?
	User.create!(email: ENV['ADMIN_EMAIL'], password: ENV['ADMIN_PASSWORD'], admin: 1)
	puts "Admin seeded"
else
	puts "Admin has been seeded already"
end