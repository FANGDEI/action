package main

import "testing"

func TestPrintHelloWorld(t *testing.T) {
	tests := []struct {
		name string
	}{
		// TODO: Add test cases.
		{"TestPrintHelloWorld"},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			PrintHelloWorld()
			t.Log("Test PASS")
		})
	}
}
