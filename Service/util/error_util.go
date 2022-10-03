package util

import "github.com/sirupsen/logrus"

func IfErr(err error) {
	if err != nil {
		logrus.Error(err)
	}
}
