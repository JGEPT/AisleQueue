package models

type Inventory struct {
  ID int `json:"id"`
  AisleId int `json:"aisleId"`
  ProductName string `json:"productName"`
  Quantity int `json:"quantity"`
}
