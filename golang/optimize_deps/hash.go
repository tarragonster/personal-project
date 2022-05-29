package main

import (
	"os/exec"
	"strings"
)

var (
	lengthHash = 4
)

func CheckHash(files []string) (string, error) {
	cmd := exec.Command("md5sum", files...)
	out, err := cmd.Output()
	if err != nil {
		return "", err
	}
	var entireHash string
	for _, line := range strings.Split(string(out), "\n") {
		if line == "" {
			continue
		}
		hash := strings.Split(line, " ")[0]
		entireHash += hash[:lengthHash]
	}
	return entireHash, nil
}
