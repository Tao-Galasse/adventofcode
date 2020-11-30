package main

import "fmt"

func validPassword(number int) bool {
	hasExactlyTwoAdjacentDigits := false
	currentAdjacentDigits := 1

	for number != 0 {
		digit1 := number % 10
		digit2 := number % 100 / 10

		if digit1 < digit2 {
			return false
		}

		if digit1 == digit2 {
			currentAdjacentDigits++
		} else {
			if currentAdjacentDigits == 2 {
				hasExactlyTwoAdjacentDigits = true
			}
			currentAdjacentDigits = 1
		}

		number = number / 10 
	}

	return hasExactlyTwoAdjacentDigits
}

func main() {
	totalValidPasswords := 0

	for number := 134564; number < 585159; number++ {
		if validPassword(number) {
			totalValidPasswords++
		}
	}

	fmt.Println(totalValidPasswords)
}
