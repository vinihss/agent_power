#!/bin/bash
set -euo pipefail

LIB_NAME=${1:-"minha-biblioteca"}

# Create library directory structure
mkdir -p "$LIB_NAME"/{src/{components,styles,index},stories,__tests__}

cat > package.json << 'PKG'
{
  "name": "minha-biblioteca",
  "version": "0.1.0",
  "private": false,
  "main": "dist/index.cjs",
  "module": "dist/index.esm.js",
  "types": "dist/types/index.d.ts",
  "scripts": {
    "build": "tsc build --project tsconfig.build.json",
    "storybook": "storybook dev -s .storybook",
    "test": "jest --passWithNoTests",
    "lint": "eslint . --ext .ts,.tsx",
    "prepublishOnly": "npm run build"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "@storybook/react": "^8.0.0",
    "@storybook/testing-library": "^8.0.0",
    "typescript": "^5.3.0",
    "jest": "^29.7.0",
    "@types/jest": "^29.5.0",
    "eslint": "^8.52.0",
    "eslint-plugin-react": "^7.33.2",
    "styled-components": "^6.0.0",
    "@storybook/testing-library": "^8.0.0"
  }
}
PKG

# tsconfig.json para biblioteca
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["ES2020", "DOM"],
    "strict": true,
    "module": "ESNext",
    "moduleResolution": "bundler",
    "declaration": true,
    "declarationMap": true,
    "strictNullChecks": true,
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "jsx": "react-jsx",
    "outDir": "dist",
    "rootDir": "src"
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist"]
}
EOF

# src/index.ts — superfície pública
cat > src/index.ts << 'EOF'
import Button from './components/Button';
import Input from './components/Input';
import Card from './components/Card';

export {
  Button,
  Input,
  Card,
  ButtonProps,
  InputProps,
  CardProps,
};

export type {
  ButtonProps,
  InputProps,
  CardProps,
};
EOF

# src/components/Button.tsx
mkdir -p src/components
cat > src/components/Button.tsx << 'EOF'
import React from 'react';
import styled from 'styled-components';

interface ButtonProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'ghost';
  onClick?: () => void;
  disabled?: boolean;
}

const ButtonStyles = styled.button`
  padding: 10px 20px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  border: none;

  &.primary {
    background: #3b82f6;
    color: white;
  }

  &.secondary {
    background: #f1f5f9;
    color: #1e293b;
  }

  &.ghost {
    background: transparent;
    border: 1px solid #e2e8f0;
    color: #1e293b;
  }
`;

export const Button: React.FC<ButtonProps> = ({ children, variant = 'primary', onClick, disabled }) => {
  return (
    <ButtonStyles as={variant} onClick={onClick} disabled={disabled}>
      {children}
    </ButtonStyles>
  );
};
EOF

# src/components/Input.tsx
cat > src/components/Input.tsx << 'EOF'
import React from 'react';
import styled from 'styled-components';

interface InputProps {
  label: string;
  type?: 'text' | 'email' | 'password';
  value?: string;
  onChange?: (value: string) => void;
  disabled?: boolean;
}

const InputStyles = styled.input`
  padding: 12px 16px;
  border: 1px solid #cbd5e0;
  border-radius: 6px;
  font-size: 14px;
  width: 100%;
  &:focus {
    outline: none;
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
  }
`;

export const Input: React.FC<InputProps> = ({ label, type = 'text', value, onChange, disabled }) => {
  return (
    <div>
      <label htmlFor="input-{Math.random().toString(36).substr(2, 9)}" style={{ display: 'block', marginBottom: '8px' }}>
        {label}
      </label>
      <InputStyles
        id="input-{Math.random().toString(36).substr(2, 9)}"
        type={type}
        value={value}
        onChange={(e) => onChange?.(e.target.value)}
        disabled={disabled}
      />
    </div>
  );
};
EOF

# src/components/Card.tsx
mkdir -p src/components
cat > src/components/Card.tsx << 'EOF'
import React from 'react';
import styled from 'styled-components';

interface CardProps {
  title: string;
  children: React.ReactNode;
  variant?: 'default' | 'outlined' | 'elevated';
}

const CardStyles = styled.div`
  padding: 24px;
  border-radius: 8px;
  background: #fff;
  border: 1px solid #e2e8f0;

  &.outlined {
    border: 2px solid #e2e8f0;
  }

  &.elevated {
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  }
`;

export const Card: React.FC<CardProps> = ({ title, children, variant = 'default' }) => {
  return (
    <CardStyles className={variant}>
      {title ? <h3 style={{ marginBottom: '16px' }}>{title}</h3> : null}
      {children}
    </CardStyles>
  );
};
EOF

# stories/Button.stories.ts
mkdir -p stories
cat > stories/Button.stories.ts << 'EOF'
import { Meta, Story } from '@storybook/react-types';
import { Button } from '../src/components/Button';

export default {
  title: 'Components/Button',
  component: Button,
  tags: ['autodocs'],
  argTypes: {
    variant: { control: { options: ['primary', 'secondary', 'ghost'] } },
    disabled: { control: 'boolean' },
  },
};

const Template: Story<ButtonProps> = (args) => <Button {...args} />;

export const Primary = Template.bind({});
Primary.args = {
  children: 'Primary Button',
  variant: 'primary',
};

export const Secondary = Template.bind({});
Secondary.args = {
  children: 'Secondary Button',
  variant: 'secondary',
};

export const Ghost = Template.bind({});
Ghost.args = {
  children: 'Ghost Button',
  variant: 'ghost',
  disabled: false,
};

export const WithClick = Template.bind({});
WithClick.args = {
  children: 'Button with onClick',
  onClick: () => alert('Clicked!'),
};
EOF

# __tests__/Button.test.ts
mkdir -p __tests__
cat > __tests__/Button.test.ts << 'EOF'
import { render, screen } from '@testing-library/react';
import { Button } from '../src/components/Button';

test('renders primary button', () => {
  render(<Button>Click me</Button>);
  const button = screen.getByRole('button', { name: /click me/i });
  expect(button).toBeInTheDocument();
});

test('renders with secondary variant', () => {
  render(<Button variant="secondary">Click me</Button>);
  const button = screen.getByRole('button', { name: /click me/i });
  expect(button).toHaveClass('secondary');
});
EOF

# eslint.config.js
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
      ...globals.node,
    },
    plugins: {
      react,
    },
  },
  rules: {
    ...react.recommended,
    'react/react-in-jsx-scope': 'off',
    'no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
  },
];
EOF;

echo "✅ React library generated successfully!"