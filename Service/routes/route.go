package routes

import (
	"encoding/json"
	"net/http"

	"github.com/Ang2Tea/L0Project/models"
	"github.com/Ang2Tea/L0Project/util"
	"github.com/gorilla/mux"
	"github.com/rs/cors"
	"github.com/sirupsen/logrus"
)

type Route struct {
	Cache *util.Cache
}

func (route *Route) Start(config models.HttpServerConfig) error {
	c := cors.New(cors.Options{
		AllowedOrigins: []string{"*"},
		AllowedMethods: []string{"GET"},
	})
	return http.ListenAndServe(":"+config.Port, c.Handler(route.createRoutes()))
}

func (route *Route) createRoutes() *mux.Router {
	r := mux.NewRouter()

	r.HandleFunc("/orders", getOrdersRoute(route.Cache)).Methods("GET")
	r.HandleFunc("/orders/{uid}", getOrderRoute(route.Cache)).Methods("GET")

	return r
}

func getOrdersRoute(cache *util.Cache) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(cache.ToSlice())

		logrus.Info("Get orders")
	}
}

func getOrderRoute(cache *util.Cache) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		params := mux.Vars(r)

		logrus.Info("Get order by order_uid")
		if order, check := cache.Get(params["uid"]); check {
			json.NewEncoder(w).Encode(order)
			return
		}
		json.NewEncoder(w).Encode("Not found")
	}
}
