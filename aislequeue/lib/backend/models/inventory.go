package models

type Inventory struct {
    ID          int     `json:"id"`
    TileID      int     `json:"tile_id"`
    ProductName string  `json:"product_name"`
    Quantity    int     `json:"quantity"`
    Price       float64 `json:"price"`
}
