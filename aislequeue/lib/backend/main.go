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

	// Layout routes
	app.Get("/layouts/:name", handlers.LoadLayout) // Changed from :id to :name
	app.Post("/save-layout", handlers.SaveLayout)
	app.Put("/update-layout/:name", handlers.UpdateLayout)
	app.Delete("/delete-layout/:name", handlers.DeleteLayout) // Changed from :id to :name
	app.Get("/layouts", handlers.ListLayouts)

	// Start server
	log.Println("Server started on :3000")
	log.Fatal(app.Listen(":3000"))
}
