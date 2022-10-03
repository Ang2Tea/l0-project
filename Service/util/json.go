package util

import (
	"encoding/json"
	"errors"
)

func ParseJson[T any](data []byte) (T, error) {
	result := new(T)
	if err := json.Unmarshal(data, result); err != nil {
		return *new(T), errors.New("invalid json")
	}

	return *result, nil
}
