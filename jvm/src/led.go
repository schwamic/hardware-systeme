package main

import (
	"fmt"
	"log"
)

func SetLeds(value int32) {
	leds := Reverse(fmt.Sprintf("%08b", value))
	log.Printf("LEDs: %v", leds)
}

func Reverse(s string) string {
	runes := []rune(s)
	for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
		runes[i], runes[j] = runes[j], runes[i]
	}
	return string(runes)
}
