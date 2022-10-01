package util

import log "github.com/sirupsen/logrus"

func IfErr(err error) {
	if err != nil {
		log.Error(err)
	}
}
