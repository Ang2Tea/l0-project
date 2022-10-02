package caches

import (
	"github.com/Ang2Tea/L0Project/models"
	"github.com/tidwall/btree"
)

type Cache struct {
	btree.Map[string, models.Order]
}

func (cache *Cache) ToSlice() []models.Order {
	orders := []models.Order{}

	cache.Scan(func(key string, value models.Order) bool {
		orders = append(orders, value)
		return true
	})

	return orders
}

func (cache *Cache) SliceTo(orders []models.Order) {
	for _, value := range orders {
		cache.Set(value.OrderUid, value)
	}
}
