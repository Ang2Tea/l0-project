package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/Ang2Tea/L0Project/database"
	"github.com/Ang2Tea/L0Project/util"
	"github.com/gorilla/mux"
	_ "github.com/lib/pq"
	"github.com/nats-io/stan.go"
)

var Orders []database.Order

func main() {
	connStr := "user=postgres password=zasuza13 dbname=for_test sslmode=disable"
	pgConnect, err := sql.Open("postgres", connStr)
	if err != nil {
		panic(err)
	}
	defer pgConnect.Close()
	Orders = SelectOrders(pgConnect)

	sc, _ := stan.Connect("test-cluster", "simple-pub")
	defer sc.Close()
	// подписка на канал для дальнейшей обработки полученных данных
	sc.Subscribe("service", GetMessage)

	r := mux.NewRouter()
	r.HandleFunc("/orders", GetOrders).Methods("GET")
	r.HandleFunc("/orders/{uid}", GetOrder).Methods("GET")
	r.HandleFunc("/orders", GetOrder).Methods("POST")

	log.Println("Server Starting...")
	log.Fatal(http.ListenAndServe(":8000", r))
}

func GetMessage(m *stan.Msg) {
	var order database.Order
	err := json.Unmarshal(m.Data, &order)

	util.IfErr(err)

	Orders = append(Orders, order)
	database.InsertData(pgConnect, order)
}

func SelectOrders(conn *sql.DB) []database.Order {
	orders := ""
	ordersStruct := []database.Order{}

	row := conn.QueryRow("select * from select_orders()")
	if err := row.Scan(&orders); err != nil {
		fmt.Println(err)
	}
	if err := json.Unmarshal([]byte(orders), &ordersStruct); err != nil {
		fmt.Println(err)
	}

	return ordersStruct
}

func AddOrder(conn *sql.DB, data string) {
	var order database.Order
	if err := json.Unmarshal([]byte(data), &order); err != nil {
		log.Println(err)
	}
	Orders = append(Orders, order)
}

func GetOrders(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(Orders)
}

func GetOrder(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	params := mux.Vars(r)
	for _, item := range Orders {
		if item.OrderUid == params["uid"] {
			json.NewEncoder(w).Encode(item)
			return
		}
	}
	json.NewEncoder(w).Encode("Not found")
}
