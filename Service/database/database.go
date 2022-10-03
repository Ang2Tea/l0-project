package database

import (
	"database/sql"
	"fmt"

	"github.com/Ang2Tea/L0Project/models"
	"github.com/Ang2Tea/L0Project/util"
	_ "github.com/lib/pq"
	"github.com/sirupsen/logrus"
)

type DBContext struct {
	*sql.DB
}

func CreateConnect(config models.PostgresConfig) (DBContext, error) {
	connStr := fmt.Sprintf("user=%s password=%s dbname=%s sslmode=%s host=%s port=%s",
		config.User,
		config.Password,
		config.DbName,
		config.SslMode,
		config.Host,
		config.Port)

	logrus.Info(connStr)

	conn, err := sql.Open("postgres", connStr)
	if err != nil {
		return DBContext{}, err
	}

	return DBContext{DB: conn}, nil
}

func (db *DBContext) SelectOrders() []models.Order {
	orders := ""

	row := db.QueryRow("select * from select_orders()")
	err := row.Scan(&orders)
	if err != nil {
		logrus.Error(err)
		return []models.Order{}
	}

	ordersStruct, err := util.ParseJson[[]models.Order]([]byte(orders))
	if err != nil {
		logrus.Error(err)
		return []models.Order{}
	}

	return ordersStruct
}

func (db *DBContext) InsertData(data models.Order) {
	if data.OrderUid != data.Payment.Transaction {
		logrus.Error("OrderUid and Transaction are different")
		return
	}

	for _, value := range data.Items {
		if data.TrackNumber != value.TrackNumber {
			logrus.Error("One of the Item track_number does not match Order track_number")
			return
		}
	}

	err := db.insertDelivery(data.Delivery)
	util.IfErr(err)

	err = db.insertPayment(data.Payment)
	util.IfErr(err)

	err = db.insertOrder(data)
	util.IfErr(err)

	for _, value := range data.Items {
		err = db.insertItem(value)
		util.IfErr(err)

		err = db.insertOrderItem(data, value)
		util.IfErr(err)
	}
}

func (db *DBContext) insertOrderItem(order models.Order, item models.Item) error {
	_, err := db.Exec("Call insert_order_item($1, $2);", order.OrderUid, item.ChrtId)
	return err
}

func (db *DBContext) insertOrder(data models.Order) error {
	_, err := db.Exec("Call insert_order($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);",
		data.OrderUid,
		data.TrackNumber,
		data.Entry,
		data.Delivery.Phone,
		data.Payment.Transaction,
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

func (db *DBContext) insertDelivery(data models.Delivery) error {
	_, err := db.Exec(`INSERT INTO public.deliveries (name, phone, zip, city, address, region, email) 
		VALUES($1, $2, $3, $4, $5 , $6 , $7);`,
		data.Name,
		data.Phone,
		data.Zip,
		data.City,
		data.Address,
		data.Region,
		data.Email)
	return err
}

func (db *DBContext) insertPayment(data models.Payment) error {
	_, err := db.Exec("Call insert_payment($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);",
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

func (db *DBContext) insertItem(data models.Item) error {
	_, err := db.Exec("Call insert_item($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);",
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
