package database

import (
	"database/sql"
	"encoding/json"

	"github.com/Ang2Tea/L0Project/util"
)

func SelectOrders(conn *sql.DB) []Order {
	orders := ""
	ordersStruct := []Order{}

	row := conn.QueryRow("select * from select_orders()")
	err := row.Scan(&orders)
	util.IfErr(err)
	err = json.Unmarshal([]byte(orders), &ordersStruct)
	util.IfErr(err)

	return ordersStruct
}

func InsertData(conn *sql.DB, data Order) {
	deliveryId := InsertDelivery(conn, data.Delivery)

	err := InsertPayment(conn, data.Payment)
	util.IfErr(err)

	err = InsertOrder(conn, data, deliveryId)
	util.IfErr(err)

	for _, value := range data.Items {
		err = InsertItem(conn, value)
		util.IfErr(err)

		err = InsertOrderItem(conn, data, value)
		util.IfErr(err)
	}
}

func InsertOrderItem(conn *sql.DB, order Order, item Item) error {
	_, err := conn.Exec("Call insert_order_item($1, $2);", order.OrderUid, item.ChrtId)
	return err
}

func InsertOrder(conn *sql.DB, data Order, delivery int64) error {
	_, err := conn.Exec("Call insert_order($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);",
		data.OrderUid,
		data.TrackNumber,
		data.Entry,
		delivery,
		data.Payment,
		data.Locale,
		data.InternalSignature,
		data.CustomerId,
		data.DeliveryService,
		data.Shardkey,
		data.SmId,
		data.DateCreated,
		data.OofShard)
	return err
}

func InsertDelivery(conn *sql.DB, data Delivery) int64 {
	var id int64
	conn.QueryRow("Call insert_deliveries(1, $2, $3, $4, $5, $6);",
		data.Name,
		data.Phone,
		data.Zip,
		data.City,
		data.Address,
		data.Region,
		data.Email).Scan(&id)
	return id
}

func InsertPayment(conn *sql.DB, data Payment) error {
	_, err := conn.Exec("Call insert_payment($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);",
		data.Transaction,
		data.RequestId,
		data.Currency,
		data.Provider,
		data.Amount,
		data.PaymentDt,
		data.Bank,
		data.DeliveryCost,
		data.GoodsTotal,
		data.CustomFee)
	return err
}

func InsertItem(conn *sql.DB, data Item) error {
	_, err := conn.Exec("Call insert_item($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);",
		data.ChrtId,
		data.Price,
		data.Rid,
		data.Name,
		data.Sale,
		data.Size,
		data.TotalPrice,
		data.NmId,
		data.Brand,
		data.Status)
	return err
}
