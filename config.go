package main

// Config holds the app's configuration
type Config struct {
	Redis struct {
		Addr string `json:"addr"`
	} `json:"redis"`

	API struct {
		HeartbeatPath string `json:"heartbeat_path"`
	} `json:"api"`

	Processor struct {
		StorageDir string `json:"storage_dir"`
	} `json:"processor"`

	Notifier struct {
		Concurrency int `json:"concurrency"`
	} `json:"notifier"`
}
