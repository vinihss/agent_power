#!/bin/bash
set -euo pipefail

PROJECT_NAME=${1:-"minha-ferramenta"}

# Create project directory
mkdir -p "$PROJECT_NAME"/{src/{commands},tests}

# Initialize npm project
cd "$PROJECT_NAME"
npm init -y > /dev/null 2>&1

# Install dependencies
npm install commander inquirer > /dev/null 2>&1
npm install -D @types/node @types/inquirer ts-jest jest > /dev/null 2>&1

# TypeScript config
cat > tsconfig.json << 'TSCONF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "strict": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "outDir": "./dist",
    "rootDir": "./src"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
TSCONF

# Source files
cat > src/index.ts << 'INDEX'
import { program } from "./commands";
program.parse process.argv;
INDEX

cat > src/commands/index.ts << 'CMDS'
import { program } from "commander";

program
  .name("minha-ferramenta")
  .description("CLI tool description");

program
  .command("create [name]")
  .description("Create a new resource")
  .argument("[name]", "Name of the resource to create")
  .action((name) => {
    console.log(`Creating resource: ${name || "unnamed"}`);
  });

program
  .command("list")
  .description("List resources")
  .action(() => {
    console.log("Listing resources...");
  });

program.parse();
INDEX

cat > src/commands/create.ts << 'CREATE'
import { Command } from "commander";

export const create = new Command()
  .command("create [name]")
  .description("Create a new resource")
  .argument("[name]", "Name of the resource to create")
  .action((name) => {
    console.log(`Creating resource: ${name || "unnamed"}`);
  });
CMDS

cat > src/commands/list.ts << 'LIST'
import { Command } from "commander";

export const list = new Command()
  .command("list")
  .description("List resources")
  .action(() => {
    console.log("Listing resources...");
  });
LIST

# Add scripts to package.json
cat > package.json << 'PKG'
{
  "name": "minha-ferramenta",
  "version": "1.0.0",
  "scripts": {
    "build": "tsc",
    "lint": "eslint . --ext .ts",
    "test": "jest"
  }
}
PKG

# Create tests
cat > tests/user.test.ts << 'TEST'
import { execSync } from "child_process";

test("CLI create command works", () => {
  const output = execSync("node dist/index.js create test-name").toString();
  expect(output).toContain("Creating resource: test-name");
});
TEST

# Create jest.config.ts
cat > jest.config.ts << 'JEST'
{
  "preset": "ts-jest",
  "testEnvironment": "node"
}
JEST

# Create .gitignore
cat > .gitignore << 'GITIGNORE'
node_modules
dist
.env
*.log
EXAMPLE

echo "✅ Node.js CLI Tool gerada com sucesso!"