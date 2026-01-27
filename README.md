# ✅ Quadros — Task Manager

Quadros Task Manager is a full-featured task management application inspired by industry standards like Jira. Built for the **Quadros** platform, it streamlines project organization, workflows, and daily productivity in a cohesive, user-friendly interface.

This is a productivity tool designed to help teams and individuals track progress, manage backlogs, and collaborate effectively.

<img width="1919" height="922" alt="image" src="https://github.com/user-attachments/assets/925f6db1-e773-4e35-b175-4a63c7c92756" />
<img width="1923" height="923" alt="image" src="https://github.com/user-attachments/assets/39d64186-4c53-4115-9b75-3acb4ec4bfd1" />

### 🔗 You can access the platform online right here: [Quadros](https://quadros-kanban.netlify.app/)

## 🎯 Features

- **Project & Board Management**: Create and manage multiple projects with customizable boards.
- **Workflow Customization**: Define columns and statuses to match your team's process.
- **Task Tracking**: Detailed task creation with descriptions, assignees, and priority levels.
- **Collaboration**: Commenting system and real-time updates for team synchronization.
- **Responsive Interface**: A modern, fast, and responsive UI built with Vue.js and Tailwind CSS.
- **Secure Authentication**: Robust user authentication and role-based access control.

## 🛠️ Tech Stack

### Frontend
- **Framework**: [Vue.js 3](https://vuejs.org/)
- **Build Tool**: [Vite](https://vitejs.dev/)
- **Styling**: [Tailwind CSS](https://tailwindcss.com/)
- **State Management**: [Pinia](https://pinia.vuejs.org/)
- **Icons**: [FontAwesome](https://fontawesome.com/)

### Backend
- **Framework**: [Ruby on Rails 7](https://rubyonrails.org/)
- **Language**: Ruby 2.7.6
- **Database**: PostgreSQL
- **Authentication**: JWT & BCrypt
- **Authorization**: Pundit

## 🧪 Running Locally

Check out the repository and follow the steps below to run the application on your local machine.

### Prerequisites

Ensure you have the following installed:
- **Ruby**: v2.7.6
- **Ruby on Rails**: v7.1.5+
- **Node.js**: v18+ (Recommended)
- **PostgreSQL**: v12+
- **Yarn** or **npm**

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd quadros
   ```

2. **Backend Setup:**
   Navigate to the backend directory and install dependencies:
   ```bash
   cd backend
   bundle install
   ```

   Setup the database:
   ```bash
   # Create database, run migrations, and seed data
   rails db:setup
   ```

   Start the Rails server:
   ```bash
   rails s
   ```
   The backend API will run on `http://localhost:3000`.

3. **Frontend Setup:**
   Open a new terminal, navigate to the frontend directory, and install dependencies:
   ```bash
   cd frontend
   npm install
   ```

   Start the development server:
   ```bash
   npm run dev
   ```
   The application will be available at the URL shown in the terminal (usually `http://localhost:5173`).

## 📁 Project Structure

```bash
quadros/
├── backend/            # Ruby on Rails API
│   ├── app/
│   ├── config/
│   ├── db/
│   └── Gemfile
├── frontend/           # Vue.js + Vite Application
│   ├── src/
│   ├── public/
│   ├── index.html
│   └── package.json
└── README.md
```

## 📚 Credits

Developed and Maintained by the **Lucas Almeida**.
