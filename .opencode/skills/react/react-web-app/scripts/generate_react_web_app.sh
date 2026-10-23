#!/bin/bash
set -euo pipefail

PROJECT_NAME=${1:-"minha_app"}

# Create react app with TypeScript template
npx create-react-app "$PROJECT_NAME" --template typescript 2>&1 | tail -5

cd "$PROJECT_NAME"

# Replace package.json scripts para usar Vite (mais rápido)
cat > package.json << 'PKG'
{
  "name": "minha_app",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "lint": "eslint .",
    "test": "jest --passWithNoTests"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "vite": "^5.2.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "@testing-library/react": "^14.0.0",
    "@testing-library/jest-dom": "^6.0.0",
    "eslint": "^8.52.0",
    "eslint-plugin-react": "^7.33.2",
    "jest": "^29.7.0",
    "ts-jest": "^29.1.0",
    "vite": "^5.2.0"
  }
}
PKG

# Add Hello component
mkdir -p src/components
cat > src/components/Hello.tsx << 'EOF'
import React from 'react';

export const Hello: React.FC = () => <div>Hello, World!</div>;
EOF

# Update src/main.tsx to use the new component
cat > src/main.tsx << 'EOF'
import React from 'react';
import ReactDOM from 'react-dom/client';
import { Hello } from './components/Hello';
import './index.css';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <Hello />
  </React.StrictMode>
);
EOF

# Add ESLint config extensões React
cat > eslint.config.js << 'EOF'
import react from eslint-plugin-react;
import tseslint from '@typescript-eslint/tseslint';
import globals from 'eslint-plugin-import/globals';

export default tseslint.defineConfig([
  ...tseslint.configs.recommended,
  ...tseslint.configs.strictTypeChecked,
  ...tseslint.configs.styleChecked,
  {
    languageOptions: {
      ...globals.browser,
      ...react.jsxPragma('react'),
      ...react.jsxPragmaFragment('fragment'),
    },
    plugins: {
      react,
    },
  },
  rules: {
    ...react.recommended,
    ...react.noUnusedProps,
    'react/no-unknown-property': ['error', { Ignore: ['size'] }],
  },
];
EOF

# Add tsconfig.json paths alias (src/*)
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "useUnknownInCatchVariables": true,
    "strict": true,
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strictNullChecks": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "forceConsistentCasingInFileNames": true,
    "strictFunctionTypes": true,
    "skipLibCheck": true,
    "isolatedModules": true,
    "jsx": "react-jsx",
    "baseUrl": ".",
    "paths": {
      "src/*": ["src/*"],
      "components/*": ["src/components/*"],
      "hooks/*": ["src/hooks/*"],
      "pages/*": ["src/pages/*"]
    },
    "plugins": ["react"],
    "rules": {
      "react/react-in-jsx-scope": "off"
    }
  },
  "include": ["src"]
}
EOF

# Add basic src/index.css
mkdir -p src
cat > src/index.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

# Add src/index.css content (sem tailwind — CSS puro)
cat > src/index.css << 'EOF'
/* Reset e base styles */
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: system-ui, -apple-system, sans-serif;
  background: #fff;
  color: #111;
  min-height: 100vh;
}

/* Variáveis globais */
:root {
  --color-primary: #3b82f6;
  --color-secondary: #1e293b;
  --color-accent: #10b981;
  --muted: #64748b;
}

/* Componentes */
.btn {
  display: inline-block;
  padding: 8px 16px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  border: none;
}

.btn-primary {
  background: var(--color-primary);
  color: #fff;
}

.btn-secondary {
  background: #f1f5f9;
  color: var(--color-secondary);
}
EOF

echo "✅ React application generated successfully!"