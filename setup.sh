#!/usr/bin/env bash
set -euo pipefail

echo "== Blockwala setup =="
if [ -f ".env.local" ]; then
  echo ".env.local already exists. Skipping env creation."
else
  echo "Creating .env.local ..."
  read -p "AUTH0_DOMAIN: " AUTH0_DOMAIN
  read -p "AUTH0_CLIENT_ID: " AUTH0_CLIENT_ID
  read -p "AUTH0_CLIENT_SECRET: " AUTH0_CLIENT_SECRET
  read -p "AUTH_SECRET (random string): " AUTH_SECRET
  read -p "DATABASE_URL: " DATABASE_URL
  read -p "NEXT_PUBLIC_SOLANA_RPC_URL: " SOL_RPC
  read -p "NEXT_PUBLIC_USDC_MINT (mainnet USDC default EPjFW...): " USDC_MINT
  read -p "COINBASE_API_KEY: " CB_API
  read -p "COINBASE_WEBHOOK_SECRET: " CB_WH

  cat > .env.local <<EOF
AUTH_PROVIDER=auth0
AUTH0_DOMAIN=${AUTH0_DOMAIN}
AUTH0_CLIENT_ID=${AUTH0_CLIENT_ID}
AUTH0_CLIENT_SECRET=${AUTH0_CLIENT_SECRET}
AUTH_SECRET=${AUTH_SECRET}
NEXTAUTH_URL=http://localhost:3000

DATABASE_URL=${DATABASE_URL}

NEXT_PUBLIC_SOLANA_RPC_URL=${SOL_RPC}
NEXT_PUBLIC_USDC_MINT=${USDC_MINT}

COINBASE_API_KEY=${CB_API}
COINBASE_WEBHOOK_SECRET=${CB_WH}
EOF
fi

echo "Installing dependencies ..."
npm i

echo "Running Prisma generate & migrate ..."
npx prisma generate
npx prisma migrate dev --name init

echo "Health check: prisma can read tables"
node -e "import('./node_modules/@prisma/client/index.js').then(async m=>{const p=new m.PrismaClient();await p.$connect(); const c=await p.$queryRaw`select now()`; console.log('DB OK:', c); await p.$disconnect();}).catch(e=>{console.error(e); process.exit(1);});"

echo "All set. Start dev with: npm run dev"
