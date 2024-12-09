package database

import (
	"database/sql"
	"log"

	_ "github.com/mattn/go-sqlite3"
)

var DB *sql.DB

func InitDatabase() {
	var err error
	DB, err = sql.Open("sqlite3", "./todo.db")
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	// Create todos table if not exists
	createTableSQL := `CREATE TABLE IF NOT EXISTS todos (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		title TEXT NOT NULL,
		completed BOOLEAN NOT NULL DEFAULT 0,
		created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
		updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
	)`

	_, err = DB.Exec(createTableSQL)
	if err != nil {
		log.Fatal("Failed to create todos table:", err)
	}
}

func CloseDatabase() {
	if DB != nil {
		DB.Close()
	}
}
