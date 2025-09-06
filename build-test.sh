#!/bin/bash

# Asagents Build & Test Script
# This script verifies that the application can be built and run successfully

set -e

echo "🚀 Asagents Build & Deployment Test"
echo "===================================="

# Check prerequisites
echo "📋 Checking prerequisites..."
command -v node >/dev/null 2>&1 || { echo "❌ Node.js is required but not installed. Aborting." >&2; exit 1; }
command -v pnpm >/dev/null 2>&1 || { echo "⚠️  pnpm not found, installing..." && npm install -g pnpm; }

NODE_VERSION=$(node --version)
echo "✅ Node.js version: $NODE_VERSION"

PNPM_VERSION=$(pnpm --version)
echo "✅ pnpm version: $PNPM_VERSION"

# Check environment file
echo ""
echo "🔧 Checking environment configuration..."
if [ ! -f ".env.local" ]; then
    echo "⚠️  .env.local not found, creating from example..."
    cp .env.example .env.local
    echo "📝 Please edit .env.local with your actual values before deploying"
fi

# Verify AUTH_SECRET is set
if grep -q "AUTH_SECRET=\*\*\*\*" .env.local; then
    echo "⚠️  AUTH_SECRET is not configured. Generating one..."
    AUTH_SECRET=$(openssl rand -base64 32)
    sed -i "s/AUTH_SECRET=\*\*\*\*/AUTH_SECRET=$AUTH_SECRET/" .env.local
    echo "✅ AUTH_SECRET generated and configured"
else
    echo "✅ AUTH_SECRET is configured"
fi

# Comment out POSTGRES_URL if it's set to placeholder
if grep -q "^POSTGRES_URL=\*\*\*\*" .env.local; then
    echo "⚠️  Commenting out placeholder POSTGRES_URL to allow building without database..."
    sed -i 's/^POSTGRES_URL=\*\*\*\*$/# POSTGRES_URL=****/' .env.local
    echo "✅ POSTGRES_URL commented out"
fi

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
pnpm install

# Run build
echo ""
echo "🔨 Building application..."
pnpm build

# Test production server
echo ""
echo "🧪 Testing production server..."
pnpm start &
SERVER_PID=$!

# Wait for server to start
sleep 5

# Test health endpoint
if curl -f -s http://localhost:3000/ping > /dev/null; then
    echo "✅ Production server is running and healthy"
else
    echo "❌ Production server health check failed"
    kill $SERVER_PID 2>/dev/null || true
    exit 1
fi

# Stop server
kill $SERVER_PID 2>/dev/null || true
sleep 2

# Test development server
echo ""
echo "🧪 Testing development server..."
timeout 30s pnpm dev &
DEV_PID=$!

# Wait for dev server to start
sleep 10

# Test health endpoint on both possible ports
if curl -f -s http://localhost:3000/ping > /dev/null 2>&1; then
    echo "✅ Development server is running and healthy on port 3000"
elif curl -f -s http://localhost:3001/ping > /dev/null 2>&1; then
    echo "✅ Development server is running and healthy on port 3001"
else
    echo "❌ Development server health check failed on both ports 3000 and 3001"
    kill $DEV_PID 2>/dev/null || true
    exit 1
fi

# Stop dev server
kill $DEV_PID 2>/dev/null || true
sleep 2

echo ""
echo "🎉 Build and deployment test completed successfully!"
echo ""
echo "Next steps:"
echo "1. 📝 Configure your environment variables in .env.local"
echo "2. 🚀 Deploy to Vercel: https://vercel.com/new/clone?repository-url=https://github.com/adrianstanca1/Asagents"
echo "3. 📖 Read the deployment guide: ./DEPLOYMENT.md"
echo ""
echo "Local commands:"
echo "- Development: pnpm dev"
echo "- Production:  pnpm build && pnpm start"
echo "- Linting:     pnpm lint"