# Admin User
admin = User.find_or_create_by!(email: 'admin@example.com') do |u|
  u.name = 'Admin User'
  u.password = 'password'
  u.role = :admin
end

# Regular User
user = User.find_or_create_by!(email: 'user@example.com') do |u|
  u.name = 'John Doe'
  u.password = 'password'
  u.role = :user
end

# Main Board
board = Board.find_or_create_by!(title: 'Project Alpha') do |b|
  b.created_by = admin
end

# Columns
todo = Column.find_or_create_by!(board: board, title: 'To Do')
in_progress = Column.find_or_create_by!(board: board, title: 'In Progress')
done = Column.find_or_create_by!(board: board, title: 'Done')

# Cards (Only if columns are empty)
if todo.cards.empty?
  Card.create!(column: todo, title: 'Setup Repo', description: 'Initialize git repo', assignee: admin, creator: admin)
end
if in_progress.cards.empty?
  Card.create!(column: in_progress, title: 'Backend API', description: 'Build Rails API', assignee: user,
               creator: admin)
end
if done.cards.empty?
  Card.create!(column: done, title: 'Planning', description: 'Write implementation plan', assignee: admin,
               creator: admin)
end

puts 'Seeding completed.'
