package main

import (
	"github.com/joho/godotenv"
	"github.com/sirupsen/logrus"

	"github.com/Ang2Tea/L0Project/database"
	"github.com/Ang2Tea/L0Project/models"
	natsstreaming "github.com/Ang2Tea/L0Project/nats-streaming"
	"github.com/Ang2Tea/L0Project/routes"
	"github.com/Ang2Tea/L0Project/util"
)

// Иницилизация переменных окружения из env файла
func init() {
	if err := godotenv.Load(); err != nil {
		logrus.Error("No .env file found")
	}
}

func main() {
	// Обработка ошибок при старте сервиса
	handler := func(err error) {
		if err != nil {
			logrus.Panic(err)
		}
	}

	// Чтение переменных окружения
	config := models.New()

	// Подключение к postgres
	logrus.Info("Connecting Postgres")
	pgConnect, err := database.CreateConnect(config.Postgres)
	handler(err)

	defer pgConnect.Close()

	// Востановление кеша
	cache := util.SliceTo(pgConnect.SelectOrders())

	// Подключение к nats-streaming
	logrus.Info("Connecting Nats-Streaming")
	nats, err := natsstreaming.ConnectNats(config.Nats, &cache)
	handler(err)

	defer nats.Close()

	nats.SubscribeNats(&pgConnect)

	// Создание http сервера
	route := routes.Route{
		Cache: &cache,
	}
	logrus.Info("Server Starting...")
	err = route.Start(config.Server)
	handler(err)
}
