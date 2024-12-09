package handlers

import (
	"encoding/json"
	"strconv"
	"backend/database"
	"backend/models"
	"github.com/gofiber/fiber/v2"
)

// SaveLayout saves a new layout
func SaveLayout(c *fiber.Ctx) error {
	layout := new(models.Layout)
	if err := c.BodyParser(layout); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request body"})
	}

	placedTilesJSON, err := json.Marshal(layout.PlacedTiles)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to marshal placed tiles"})
	}

	result, err := database.DB.Exec("INSERT INTO layouts (placed_tiles) VALUES (?)", placedTilesJSON)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to save layout"})
	}

	id, _ := result.LastInsertId()
	layout.ID = int(id)

	return c.Status(201).JSON(layout)
}

// LoadLayout retrieves a layout by ID
func LoadLayout(c *fiber.Ctx) error {
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid layout ID"})
	}

	var layout models.Layout
	var placedTilesJSON string

	err = database.DB.QueryRow("SELECT placed_tiles FROM layouts WHERE id = ?", id).Scan(&placedTilesJSON)
	if err != nil {
		return c.Status(404).JSON(fiber.Map{"error": "Layout not found"})
	}

	if err := json.Unmarshal([]byte(placedTilesJSON), &layout.PlacedTiles); err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to unmarshal placed tiles"})
	}

	layout.ID = id
	return c.JSON(layout)
}

// UpdateLayout modifies an existing layout
func UpdateLayout(c *fiber.Ctx) error {
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid layout ID"})
	}

	layout := new(models.Layout)
	if err := c.BodyParser(layout); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request body"})
	}

	placedTilesJSON, err := json.Marshal(layout.PlacedTiles)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to marshal placed tiles"})
	}

	_, err = database.DB.Exec("UPDATE layouts SET placed_tiles = ? WHERE id = ?", placedTilesJSON, id)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to update layout"})
	}

	layout.ID = id
	return c.JSON(layout)
}

// DeleteLayout removes a layout by ID
func DeleteLayout(c *fiber.Ctx) error {
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"error": " Invalid layout ID"})
	}

	_, err = database.DB.Exec("DELETE FROM layouts WHERE id = ?", id)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to delete layout"})
	}

	return c.SendStatus(204)
}
