#!/bin/bash
set -euo pipefail

PROJECT_NAME=${1:-"minha-ferramenta"}

mkdir -p "$PROJECT_NAME"/{cmd/internal}

cat > "$PROJECT_NAME/go.mod" << 'EOF'
module $PROJECT_NAME

go 1.22
EOF

cat > "$PROJECT_NAME/main.go" << 'EOF'
package main

import (
    "fmt"
    "os"

    "github.com/spf13/cobra"
)

func main() {
    rootCmd := &cobra.Command{
        Use:   "$PROJECT_NAME",
        Short: "CLI tool description",
        Long:  "Uma ferramenta de linha de comando em Go com Cobra",
        Run: func(cmd *cobra.Command, args []string) {
            // Default behavior when no subcommand is provided
            fmt.Printf("Hello! This is %s CLI.\n", os.Args[0])
        },
    }

    rootCmd.PersistentFlags().String("config", "", "Path to config file")
    rootCmd.Execute()
EOF

cat > "$PROJECT_NAME/cmd/root.go" << 'EOF'
package main

import (
    "fmt"

    "github.com/spf13/cobra"
)

func init() {
    rootCmd := &cobra.Command{
        Use:   "$PROJECT_NAME",
        Short: "CLI tool description",
        Long:  "Uma ferramenta de linha de comando em Go com Cobra",
        Run: func(cmd *cobra.Command, args []string) {
            fmt.Println("Running CLI tool...")
        },
    }

    rootCmd.AddCommand(createCmd, listCmd, versionCmd)
}

var createCmd = &cobra.Command{
    Use:   "create",
    Short: "Create a resource",
    Long:  "Create a new resource with the given name",
    Args:  cobra.ExactArgs(1),
    Run: func(cmd *cobra.Command, args []string) {
        fmt.Printf("Creating resource: %s\n", args[0])
    },
}

var listCmd = &cobra.Command{
    Use:   "list",
    Short: "List resources",
    Long:  "List all resources",
    Run: func(cmd *cobra.Command, args []string) {
        fmt.Println("Listing resources...")
    },
}

var versionCmd = &cobra.Command{
    Use:   "version",
    Short: "Show version",
    Long:  "Show the version of the CLI tool",
    Run: func(cmd *cobra.Command, args []string) {
        fmt.Println("1.0.0")
    },
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

echo "✅ Go CLI Tool gerada com sucesso!"