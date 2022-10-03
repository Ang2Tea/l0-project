package natsstreaming

import (
	"errors"

	"github.com/Ang2Tea/L0Project/database"
	"github.com/Ang2Tea/L0Project/models"
	"github.com/Ang2Tea/L0Project/util"
	"github.com/nats-io/stan.go"
	"github.com/sirupsen/logrus"
)

type NatsStreamig struct {
	stan.Conn
	Cache *util.Cache
}

func ConnectNats(config models.NatsConfig, cache *util.Cache) (NatsStreamig, error) {
	var sc stan.Conn
	var err error
	if config.Address != "" && config.Port != "" {
		sc, err = stan.Connect(config.CluterID, "lo-service", stan.NatsURL("nats://"+config.Address+":"+config.Port))
	} else {
		sc, err = stan.Connect(config.CluterID, "lo-service")
	}

	if err != nil {
		return NatsStreamig{}, errors.New("failed to connect to Nats")
	}

	return NatsStreamig{Conn: sc, Cache: cache}, nil
}

func (nats *NatsStreamig) SubscribeNats(db *database.DBContext) {
	nats.Subscribe("order_service", func(m *stan.Msg) {
		// Сделать валидацию данных
		order, err := util.ParseJson[models.Order](m.Data)
		if err != nil {
			logrus.Error(err)
			return
		}

		logrus.Info("Add order in cache & database")

		nats.Cache.Set(order.OrderUid, order)
		db.InsertData(order)
	})
}
