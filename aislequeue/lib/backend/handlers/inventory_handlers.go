package handlers

import (
    "backend/database"
    "backend/models"
    "github.com/gofiber/fiber/v2"
    "net/url"
)

// SaveInventoryForLayout saves inventory items for a specific layout and tile category
func SaveInventoryForLayout(c *fiber.Ctx) error {
    // Parse the request body
    var inventoryRequest struct {
        LayoutName     string                `json:"layout_name"`
        TileCategory   string                `json:"tile_category"`
        InventoryItems []models.InventoryItem `json:"inventory_items"`
    }

    if err := c.BodyParser(&inventoryRequest); err != nil {
        return c.Status(400).JSON(fiber.Map{"error": "Invalid request body"})
    }

    // Start a transaction
    tx, err := database.DB.Begin()
    if err != nil {
        return c.Status(500).JSON(fiber.Map{"error": "Failed to start transaction"})
    }

    // First, delete existing inventory for this layout and category
    _, err = tx.Exec("DELETE FROM inventory WHERE layout_name = ? AND tile_category = ?", 
        inventoryRequest.LayoutName, inventoryRequest.TileCategory)
    if err != nil {
        tx.Rollback()
        return c.Status(500).JSON(fiber.Map{"error": "Failed to clear existing inventory"})
    }

    // Prepare the insert statement
    stmt, err := tx.Prepare("INSERT INTO inventory (id, layout_name, tile_category, item_name, quantity, price) VALUES (?, ?, ?, ?, ?, ?)")
    if err != nil {
        tx.Rollback()
        return c.Status(500).JSON(fiber.Map{"error": "Failed to prepare insert statement"})
    }
    defer stmt.Close()

    // Insert new inventory items
    for _, item := range inventoryRequest.InventoryItems {
        _, err = stmt.Exec(
            item.ID, 
            inventoryRequest.LayoutName, 
            inventoryRequest.TileCategory, 
            item.Name, 
            item.Quantity, 
            item.Price,
        )
        if err != nil {
            tx.Rollback()
            return c.Status(500).JSON(fiber.Map{"error": "Failed to insert inventory item"})
        }
    }

    // Commit the transaction
    err = tx.Commit()
    if err != nil {
        return c.Status(500).JSON(fiber.Map{"error": "Failed to commit transaction"})
    }

    return c.Status(200).JSON(fiber.Map{"message": "Inventory saved successfully"})
}

// LoadInventoryForLayoutAndCategory retrieves inventory for a specific layout and tile category
func LoadInventoryForLayoutAndCategory(c *fiber.Ctx) error {
    layoutName := c.Params("layout_name")
    tileCategory := c.Params("tile_category")

    // Decode the parameters
    layoutName, err := url.QueryUnescape(layoutName)
    if err != nil {
        return c.Status(400).JSON(fiber.Map{"error": "Invalid layout name"})
    }
    tileCategory, err = url.QueryUnescape(tileCategory)
    if err != nil {
        return c.Status(400).JSON(fiber.Map{"error": "Invalid tile category"})
    }

    // Query inventory items
    rows, err := database.DB.Query(
        "SELECT id, item_name, quantity, price FROM inventory WHERE layout_name = ? AND tile_category = ?", 
        layoutName, tileCategory,
    )
    if err != nil {
        return c.Status(500).JSON(fiber.Map{"error": "Failed to retrieve inventory"})
    }
    defer rows.Close()

    // Prepare slice to store inventory items
    var inventoryItems []models.InventoryItem
    for rows.Next() {
        var item models.InventoryItem
        err := rows.Scan(&item.ID, &item.Name, &item.Quantity, &item.Price)
        if err != nil {
            return c.Status(500).JSON(fiber.Map{"error": "Failed to scan inventory item"})
        }
        inventoryItems = append(inventoryItems, item)
    }

    return c.JSON(inventoryItems)
}
