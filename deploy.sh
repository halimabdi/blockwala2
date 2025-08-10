#!/usr/bin/env bash
set -euo pipefail

if ! command -v vercel >/dev/null 2>&1; then
  echo "Installing Vercel CLI ..."
  npm i -g vercel
fi

echo "== Linking to Vercel project (blockwala) =="
vercel link --yes --project blockwala || true

echo "== Syncing environment variables to Vercel =="
while IFS='=' read -r key value
do
  if [[ -n "$key" && "$key" != \#* && -n "$value" ]]; then
    echo "Setting $key"
    printf "%s\n" "$value" | vercel env add "$key" production || true
    printf "%s\n" "$value" | vercel env add "$key" preview || true
    printf "%s\n" "$value" | vercel env add "$key" development || true
  fi
done < .env.local

echo "== Deploying to Vercel (prod) =="
vercel deploy --prod

echo "Done. If you created a Coinbase webhook, point it to: https://<your-vercel-domain>/api/onramp/webhook"
