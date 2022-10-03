package models

import "os"

type PostgresConfig struct {
	User, Password, DbName, SslMode, Host, Port string
}

type NatsConfig struct {
	CluterID, ClientID, Address, Port string
}

type HttpServerConfig struct {
	Port string
}

type Config struct {
	Postgres PostgresConfig
	Nats     NatsConfig
	Server   HttpServerConfig
}

func New() Config {
	return Config{
		Postgres: PostgresConfig{
			User:     getEnv("POSTGRES_USER"),
			Password: getEnv("POSTGRES_PASSWORD"),
			DbName:   getEnv("POSTGRES_DB"),
			SslMode:  getEnv("POSTGRES_SSL"),
			Host:     getEnv("POSTGRES_HOST"),
			Port:     getEnv("POSTGRES_PORT"),
		},
		Nats: NatsConfig{
			CluterID: getEnv("NATS_CLUSTER_ID"),
			ClientID: getEnv("NATS_CLIENT_ID"),
			Address:  getEnv("NATS_ADDRESS"),
			Port:     getEnv("NATS_PORT"),
		},
		Server: HttpServerConfig{
			Port: getEnv("SERVER_PORT"),
		},
	}
}

func getEnv(key string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}

	return ""
}
