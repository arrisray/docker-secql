package main

import (
	_http "github.com/arrisray/secql/internal/app/http"
	"github.com/arrisray/secql/internal/app/mysql"
	"log"
	"net/http"
)

func main() {
	// Create DB
	db, err := mysql.NewDB("admin:admin@tcp(db:3306)/secdb")
	if err != nil {
		log.Panic(err)
	}

	// Create service(s)
	companyService := &mysql.CompanyService{DB: db}

	// Setup HTTP handler
	h, _ := _http.NewHandler()
	h.CompanyService = companyService

	// Start server
	http.ListenAndServe("0.0.0.0:3000", h)
}
