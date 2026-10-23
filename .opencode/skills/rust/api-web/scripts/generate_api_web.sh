#!/bin/bash
set -euo pipefail

PROJECT_NAME=${1:-"my_web_api"}
cargo new --bin "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Create the layered directory structure
mkdir -p src/{routes,domain,infra} tests

# Manifest with the required dependencies
cat << 'EOF' > Cargo.toml
[package]
name = "my_web_api"
version = "0.1.0"
edition = "2024"

[dependencies]
tokio = { version = "1", features = ["full"] }
axum = "0.8"
serde = { version = "1", features = ["derive"] }
serde_json = "1"
sqlx = { version = "0.9", features = ["runtime-tokio", "tls-native-tls", "postgres"] }
async-trait = "0.1"
dotenvy = "0.15"
tower-http = { version = "0.7", features = ["trace"] }
tracing = "0.1"
tracing-subscriber = { version = "0.3", features = ["env-filter"] }
EOF

# Example environment file (never commit it)
echo "DATABASE_URL=postgres://user:password@localhost:5432/my_db" > .env
echo "PORT=3000" >> .env
echo ".env" >> .gitignore

# Base structured code
cat << 'EOF' > src/lib.rs
pub mod config;
pub mod domain;
pub mod infra;
pub mod routes;
EOF

cat << 'EOF' > src/config.rs
pub struct Config {
    pub database_url: String,
    pub port: u16,
}

impl Config {
    pub fn from_env() -> Self {
        Self {
            database_url: std::env::var("DATABASE_URL").unwrap_or_default(),
            port: std::env::var("PORT")
                .unwrap_or_default()
                .parse()
                .unwrap_or(3000),
        }
    }
}
EOF

cat << 'EOF' > src/domain/mod.rs
pub mod errors;
pub mod user;
EOF

cat << 'EOF' > src/domain/user.rs
use async_trait::async_trait;

pub struct User {
    pub id: u64,
    pub name: String,
}

#[async_trait]
pub trait UserRepository {
    async fn save(&self, user: User) -> Result<(), String>;
}
EOF

cat << 'EOF' > src/domain/errors.rs
pub enum AppError {
    NotFound,
    Internal(String),
}
EOF

cat << 'EOF' > src/infra/mod.rs
pub mod cryptography;
pub mod db_sqlx;
EOF

cat << 'EOF' > src/infra/db_sqlx.rs
use crate::domain::user::{User, UserRepository};
use async_trait::async_trait;

pub struct SqlxRepository;

#[async_trait]
impl UserRepository for SqlxRepository {
    async fn save(&self, _user: User) -> Result<(), String> {
        // Real SQLx integration would go here
        Ok(())
    }
}
EOF

cat << 'EOF' > src/infra/cryptography.rs
pub fn hash_password(_password: &str) -> String {
    "secure_hash".to_string()
}
EOF

cat << 'EOF' > src/routes/mod.rs
use axum::{Router, routing::get};
use tower_http::trace::TraceLayer;

pub fn build_router() -> Router {
    Router::new()
        .route("/health", get(|| async { "OK" }))
        .layer(TraceLayer::new_for_http())
}
EOF

cat << 'EOF' > src/main.rs
use my_web_api::config::Config;
use my_web_api::routes::build_router;

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt::init();
    dotenvy::dotenv().ok();
    let config = Config::from_env();
    let app = build_router();
    let addr = format!("0.0.0.0:{}", config.port);
    let listener = tokio::net::TcpListener::bind(&addr).await.unwrap();
    println!("🚀 Server running at http://localhost:{}", config.port);
    axum::serve(listener, app).await.unwrap();
}
EOF

cat << 'EOF' > tests/api_tests.rs
use my_web_api::config::Config;

#[test]
fn config_basic_structure() {
    let config = Config {
        database_url: "postgres://localhost/test".to_string(),
        port: 3000,
    };
    assert_eq!(config.port, 3000);
    assert!(!config.database_url.is_empty());
}
EOF

# cargo new used the real project name; align the heredoc manifests and imports
sed -i "s/my_web_api/${PROJECT_NAME}/g" Cargo.toml src/main.rs tests/api_tests.rs

echo "✅ Web API architecture generated successfully!"
