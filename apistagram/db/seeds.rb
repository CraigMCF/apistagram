# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


AppConfiguration['tags'].each do |tag|
	tag = Tag.create(:name => tag)
end

user = User.first

if user
  user.update_attribute(:is_admin, true)
end