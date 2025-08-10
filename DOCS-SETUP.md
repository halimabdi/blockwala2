# Detailed Setup

## Prereqs you should prepare
- Supabase Postgres (or Neon) → copy `DATABASE_URL` (prefer pooled/pgbouncer + sslmode=require)
- Auth0 Application → Domain, Client ID, Client Secret
- Solana RPC URL (QuickNode/Helius or mainnet public)
- USDC Mint:
  - Mainnet: EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v
  - Devnet: use a devnet USDC mint (if testing on devnet)
- Coinbase Commerce → API Key + Webhook Secret
- (Optional) Vercel Account Token
- (Optional) GitHub PAT (repo scope) if you want scripts to push automatically

## Run scripts
- `./setup.sh` — creates `.env.local`, installs deps, runs Prisma migrate, basic health checks.
- `./deploy.sh` — links to Vercel, syncs env vars, deploys to production, prints URL.
