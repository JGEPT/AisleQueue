package handlers

import (
	"time"
	"strconv"
	"backend/database"
	"backend/models"

	"github.com/gofiber/fiber/v2"
)

// GetTodos retrieves all todos
func GetTodos(c *fiber.Ctx) error {
	rows, err := database.DB.Query("SELECT id, title, completed, created_at, updated_at FROM todos")
	if err != nil {
		return c.Status(500).JSON(fiber.Map{
			"error": "Failed to retrieve todos",
		})
	}
	defer rows.Close()

	todos := []models.Todo{}
	for rows.Next() {
		var todo models.Todo
		if err := rows.Scan(&todo.ID, &todo.Title, &todo.Completed, &todo.CreatedAt, &todo.UpdatedAt); err != nil {
			return c.Status(500).JSON(fiber.Map{
				"error": "Failed to scan todo",
			})
		}
		todos = append(todos, todo)
	}

	return c.JSON(todos)
}

// CreateTodo adds a new todo
func CreateTodo(c *fiber.Ctx) error {
	todo := new(models.Todo)
	if err := c.BodyParser(todo); err != nil {
		return c.Status(400).JSON(fiber.Map{
			"error": "Invalid request body",
		})
	}

	now := time.Now()
	result, err := database.DB.Exec(
		"INSERT INTO todos (title, completed, created_at, updated_at) VALUES (?, ?, ?, ?)", 
		todo.Title, todo.Completed, now, now,
	)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{
			"error": "Failed to create todo",
		})
	}

	id, _ := result.LastInsertId()
	todo.ID = int(id)
	todo.CreatedAt = now
	todo.UpdatedAt = now

	return c.Status(201).JSON(todo)
}

// UpdateTodo modifies an existing todo
func UpdateTodo(c *fiber.Ctx) error {
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(400).JSON(fiber.Map{
			"error": "Invalid todo ID",
		})
	}

	todo := new(models.Todo)
	if err := c.BodyParser(todo); err != nil {
		return c.Status(400).JSON(fiber.Map{
			"error": "Invalid request body",
		})
	}

	now := time.Now()
	_, err = database.DB.Exec(
		"UPDATE todos SET title = ?, completed = ?, updated_at = ? WHERE id = ?", 
		todo.Title, todo.Completed, now, id,
	)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{
			"error": "Failed to update todo",
		})
	}

	todo.ID = id
	todo.UpdatedAt = now
	return c.JSON(todo)
}

// DeleteTodo removes a todo by ID
func DeleteTodo(c *fiber.Ctx) error {
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(400).JSON(fiber.Map{
			"error": "Invalid todo ID",
		})
	}

	_, err = database.DB.Exec("DELETE FROM todos WHERE id = ?", id)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{
			"error": "Failed to delete todo",
		})
	}

	return c.SendStatus(204)
}
