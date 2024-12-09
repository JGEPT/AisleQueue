# Go SQLite Todo Backend

## Overview
This is a simple Todo backend application built with Go, using Fiber web framework and SQLite as the database.

## Prerequisites
- Go 1.21 or later
- SQLite3

## Installation

1. Clone the repository
```bash
git clone https://your-repo-url.git
cd todo-backend
```

2. Install dependencies
```bash
go mod tidy
```

## Running the Application
```bash
go run main.go
```

The server will start on `http://localhost:3000`

## API Endpoints
- `GET /todos` - Retrieve all todos
- `POST /todos` - Create a new todo
- `PUT /todos/:id` - Update an existing todo
- `DELETE /todos/:id` - Delete a todo

## Making requests in windows
# Create a new todo
- Invoke-RestMethod -Uri "http://localhost:3000/todos" -Method Post -ContentType "application/json" -Body '{"title":"Buy groceries","completed":false}'

# Get all todos
- Invoke-RestMethod -Uri "http://localhost:3000/todos" -Method Get

# Update a todo (replace 1 with the actual ID)
- Invoke-RestMethod -Uri "http://localhost:3000/todos/1" -Method Put -ContentType "application/json" -Body '{"title":"Buy groceries","completed":true}'

# Delete a todo (replace 1 with the actual ID)
- Invoke-RestMethod -Uri "http://localhost:3000/todos/1" -Method Delete

## Project Structure
- `main.go`: Entry point of the application
- `database/database.go`: Database initialization and connection
- `models/todo.go`: Todo data model
- `handlers/todo_handlers.go`: API request handlers

## Database
The application uses SQLite, with the database file `todo.db` created in the project root.

## Dependencies
- Fiber Web Framework
- SQLite3 Driver

## License
[Your License Here]
