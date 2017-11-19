package http

import (
	"net/http"
)

func (h *Handler) getCompany(w http.ResponseWriter, r *http.Request) {
	// cik, _ := env.db.GetCIK()
	w.Write([]byte("/company"))
}
