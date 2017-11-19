package main

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
)

func sign(text string) {
	key := "NhqPtmdSJYdKjVHjA7PZj4Mge3R5YNiP1e3UZjInClVN65XAbvqqM6A7H5fATj0j"
	sig := hmac.New(sha256.New, []byte(key))
	sig.Write([]byte(text))
	fmt.Println(hex.EncodeToString(sig.Sum(nil)))
}

func signit() {
	text := "symbol=LTCBTC&side=BUY&type=LIMIT&timeInForce=GTC&quantity=1&price=0.1&recvWindow=5000&timestamp=1499827319559"
	sign(text)
}

func main() {
	
}
