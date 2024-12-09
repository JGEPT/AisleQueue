package models

type Layout struct {
    ID         int             `json:"id"`
    Name       string          `json:"name"` // New field for layout name
    PlacedTiles []PlacedTileData `json:"placedTiles"`
}

type PlacedTileData struct {
	GridX   int    `json:"gridX"`
	GridY   int    `json:"gridY"`
	Width   int    `json:"width"`
	Height  int    `json:"height"`
	Category string `json:"category"`
  Type string `json:"type"`
}
