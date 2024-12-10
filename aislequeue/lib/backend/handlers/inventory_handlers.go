package handlers

import (
    "backend/database"
    "backend/models"
    "github.com/gofiber/fiber/v2"
)

// AddInventory adds a new inventory item
func AddInventory(c *fiber.Ctx) error {
    inventory := new(models.Inventory)
    if err := c.BodyParser(inventory); err != nil {
        return c.Status(400).JSON(fiber.Map{"error": "Invalid request body"})
    }

    result, err := database.DB.Exec("INSERT INTO inventory (aisle_id, product_name, quantity) VALUES (?, ?, ?)", inventory.AisleId, inventory.ProductName, inventory.Quantity)
    if err != nil {
        return c.Status(500).JSON(fiber.Map{"error": "Failed to add inventory"})
    }

    id, _ := result.LastInsertId()
    inventory.ID = int(id)

    return c.Status(201).JSON(inventory)
}

// GetInventory retrieves all inventory items for a specific aisle
func GetInventory(c *fiber.Ctx) error {
    aisleId := c.Params("aisleId")
    rows, err := database.DB.Query("SELECT id, aisle_id, product_name, quantity FROM inventory WHERE aisle_id = ?", aisleId)
    if err != nil {
        return c.Status(500).JSON(fiber.Map{"error": "Failed to retrieve inventory"})
    }
    defer rows.Close()

    var inventoryItems []models.Inventory
    for rows.Next() {
        var inventory models.Inventory
        if err := rows.Scan(&inventory.ID, &inventory.AisleId, &inventory.ProductName, &inventory.Quantity); err != nil {
            return c.Status(500).JSON(fiber.Map{"error": "Failed to scan inventory"})
        }
        inventoryItems = append(inventoryItems, inventory)
    }

    return c.JSON(inventoryItems)
}

// UpdateInventory modifies an existing inventory item
func UpdateInventory(c *fiber.Ctx) error {
    id := c.Params("id")
    inventory := new(models.Inventory)
    if err := c.BodyParser(inventory); err != nil {
        return c.Status(400).JSON(fiber.Map{"error": "Invalid request body"})
    }

    _, err := database.DB.Exec("UPDATE inventory SET product_name = ?, quantity = ? WHERE id = ?", inventory.ProductName, inventory.Quantity, id)
    if err != nil {
        return c.Status(500).JSON(fiber.Map{"error": "Failed to update inventory"})
    }

    return c.JSON(inventory)
}

// DeleteInventory removes an inventory item by ID
func DeleteInventory(c *fiber.Ctx) error {
    id := c.Params("id")
    _, err := database.DB.Exec("DELETE FROM inventory WHERE id = ?", id)
    if err != nil {
        return c.Status(500).JSON(fiber.Map{"error": "Failed to delete inventory"})
    }

    return c.SendStatus(204)
}
