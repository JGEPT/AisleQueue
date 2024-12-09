package main

import (
	"backend/database"
	"backend/handlers"
	"log"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/logger"
)

func main() {
	// Initialize database
	database.InitDatabase()
	defer database.CloseDatabase()

	// Create Fiber app
	app := fiber.New()

	// Middleware
	app.Use(cors.New())
	app.Use(logger.New())

	// Routes
	app.Get("/todos", handlers.GetTodos)
	app.Post("/todos", handlers.CreateTodo)
	app.Put("/todos/:id", handlers.UpdateTodo)
	app.Delete("/todos/:id", handlers.DeleteTodo)
	app.Get("/layouts/:id", handlers.LoadLayout)
	app.Post("/save-layout", handlers.SaveLayout)
	app.Put("/update-layout/:id", handlers.UpdateLayout)
  app.Delete("/delete-layout/:id", handlers.DeleteLayout)

	// Start server
	log.Println("Server started on :3000")
	log.Fatal(app.Listen("0.0.0.0:3000"))
}
