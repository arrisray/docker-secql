package http

import (
	"net/http"
)

func (h *Handler) getHome(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("/home"))
}
