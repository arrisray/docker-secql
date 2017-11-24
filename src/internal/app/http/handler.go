package http

import (
	"github.com/arrisray/secql/internal/app"
	"github.com/go-chi/chi"
)

type Handler struct {
	*chi.Mux
	CompanyService secql.CompanyService
}

func NewHandler() (*Handler, error) {
	h := &Handler{Mux: chi.NewRouter()}
	h.Get("/", h.getHome)
	h.Get("/company/{id}", h.getCompany)
	h.Get("/parse", h.parse)
	return h, nil
}
