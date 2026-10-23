#!/bin/bash
set -euo pipefail

PROJECT_NAME=${1:-"minha-api"}

mkdir -p "$PROJECT_NAME"/{internal/config,internal/db,internal/api,v1,cmd/api}

cat > "$PROJECT_NAME/go.mod" << 'EOF'
module $PROJECT_NAME

go 1.22
EOF

cat > "$PROJECT_NAME/main.go" << 'EOF'
package main

import (
    "fmt"
    "log"
    "os"

    "$PROJECT_NAME/internal/config"
    "$PROJECT_NAME/internal/db"
    "$PROJECT_NAME/internal/middleware"
    "$PROJECT_NAME/api/v1/router"
)

func main() {
    cfg := config.Load()
    defer cfg.Close()

    dbconn := db.Connect(cfg.DATABASE_URL)
    defer dbconn.Close()

    router := router.Setup(cfg.Port)

    router.Use(middleware.Logger)
    router.Use(middleware.Recover)
    router.Use(middleware.CORS)

    log.Fatal(router.Run(cfg.Port))
}
EOF

cat > "$PROJECT_NAME/internal/config/config.go" << 'EOF'
package config

import (
    "fmt"
    "os"
    "strings"

    "github.com/spf13/viper"
)

type Config struct {
    DATABASE_URL string
    PORT         string
    ENV          string
}

func Load() *Config {
    viper.SetConfigName("config")
    viper.SetConfigType("yaml")
    viper.AddConfigPath(".")

    viper.AutomaticEnv()
    viper.SetEnvKeyReplacer(strings.NewReplacer(".", "_"))

    if err := viper.ReadInConfig(); err != nil {
        log.Printf("Warning: using environment variables only")
    }

    return &Config{
        DATABASE_URL: getRequired("DATABASE_URL"),
        PORT:         getDefault("PORT", "8080"),
        ENV:          getEnv("ENV", "development"),
    }
}

func getRequired(k string) string {
    v := os.Getenv(k)
    if v == "" && viper.IsSet(k) {
        v = viper.GetString(k)
    }
    if v == "" {
        log.Fatalf("Environment variable %s is required", k)
    }
    return v
}

func getEnv(k, d string) string {
    v := os.Getenv(k)
    if v == "" {
        return d
    }
    return v
}

func getDefault(k, d string) string {
    v := os.Getenv(k)
    if v == "" {
        return d
    }
    return v
}
EOF

cat > "$PROJECT_NAME/internal/db/db.go" << 'EOF'
package db

import (
    "database/sql"
    "fmt"
    "log"

    _ "github.com/go-sql-driver/mysql"
)

func Connect(dsn string) *sql.DB {
    db, err := sql.Open("mysql", dsn)
    if err != nil {
        log.Fatalf("Failed to connect to database: %v", err)
    }

    if err := db.Ping(); err != nil {
        log.Fatalf("Failed to ping database: %v", err)
    }

    return db
}
EOF

cat > "$PROJECT_NAME/api/v1/router.go" << 'EOF'
package v1

import (
    "github.com/gin-gonic/gin"
    "$PROJECT_NAME/internal/middleware"
)

func Setup(port string) *gin.Engine {
    router := gin.New()

    api := router.Group("/api/v1")
    {
        api.GET("/health", func(c *gin.Context) {
            c.JSON(200, gin.H{"status": "ok"})
        })

        api.GET("/status", func(c *gin.Context) {
            c.JSON(200, gin.H{
                "environment": cfg.ENV,
                "version":     "1.0.0",
            })
        })
    }

    return router
}
EOF

cat > "$PROJECT_NAME/Dockerfile" << 'EOF'
FROM golang:1.22-alpine AS builder

WORKDIR /build

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./
RUN go build -o app .

FROM alpine:3.19
WORKDIR /

COPY --from=builder /build/app /app

EXPOSE 8080

CMD ["/app"]
EOF

echo "✅ Go Web Application gerada com sucesso!"