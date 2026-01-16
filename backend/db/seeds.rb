# Admin User
admin = User.create!(
  name: 'Admin User',
  email: 'admin@example.com',
  password: 'password',
  role: :admin
)

# Regular User
user = User.create!(
  name: 'John Doe',
  email: 'user@example.com',
  password: 'password',
  role: :user
)

# Main Board
board = Board.create!(
  title: 'Project Alpha',
  created_by: admin
)

# Columns
todo = Column.create!(board: board, title: 'To Do')
in_progress = Column.create!(board: board, title: 'In Progress')
done = Column.create!(board: board, title: 'Done')

# Cards
Card.create!(column: todo, title: 'Setup Repo', description: 'Initialize git repo', assignee: admin)
Card.create!(column: in_progress, title: 'Backend API', description: 'Build Rails API', assignee: user)
Card.create!(column: done, title: 'Planning', description: 'Write implementation plan', assignee: admin)

puts "Seeding completed."

