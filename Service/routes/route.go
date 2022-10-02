package routes

import (
	"encoding/json"
	"net/http"

	"github.com/Ang2Tea/L0Project/caches"
	"github.com/Ang2Tea/L0Project/models"
	"github.com/gorilla/mux"
)

type Route struct {
	Cache  caches.Cache
	Config models.Config
}

func (route *Route) Start() error {
	return http.ListenAndServe(route.Config.Server.Port, route.createRoutes())
}

func (route *Route) createRoutes() *mux.Router {
	r := mux.NewRouter()

	r.HandleFunc("/orders", getOrdersRoute(route.Cache)).Methods("GET")
	r.HandleFunc("/orders/{uid}", getOrderRoute(route.Cache)).Methods("GET")

	return r
}

func getOrdersRoute(cache caches.Cache) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(cache.ToSlice())
	}
}

func getOrderRoute(cache caches.Cache) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		params := mux.Vars(r)

		if order, check := cache.Get(params["uid"]); check {
			json.NewEncoder(w).Encode(order)
			return
		}
		json.NewEncoder(w).Encode("Not found")
	}
}
