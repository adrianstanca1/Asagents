# Asagents - Deployment Guide

This guide provides comprehensive instructions for building and deploying the Asagents AI Chatbot application.

## ✅ Build Status

The application has been successfully built and tested:
- ✅ Dependencies installed with pnpm
- ✅ Environment configured for build without database
- ✅ Production build completed successfully
- ✅ Production server tested and working

## 🚀 Quick Deploy to Vercel (Recommended)

The easiest way to deploy this application is using Vercel's one-click deployment:

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https%3A%2F%2Fgithub.com%2Fadri
anstanca1%2FAsagents&env=AUTH_SECRET,XAI_API_KEY&envDescription=Learn+more+about+environment+variables&envLink=https%3A%2F%2Fgithub.com%2Fadri
anstanca1%2FAsagents%2Fblob%2Fmain%2F.env.example)

### Required Environment Variables for Vercel:

1. **AUTH_SECRET** (Required)
   - Generate with: `openssl rand -base64 32`
   - Or use: https://generate-secret.vercel.app/32

2. **XAI_API_KEY** (Required for AI functionality)
   - Get your xAI API Key: https://console.x.ai/

### Optional Environment Variables:

3. **POSTGRES_URL** (Optional - for persistent data)
   - Instructions: https://vercel.com/docs/storage/vercel-postgres/quickstart
   - The app works without this for testing

4. **BLOB_READ_WRITE_TOKEN** (Optional - for file uploads)
   - Instructions: https://vercel.com/docs/storage/vercel-blob

5. **REDIS_URL** (Optional - for caching)
   - Instructions: https://vercel.com/docs/redis

## 🛠️ Manual Deployment Steps

### Prerequisites
- Node.js 18+
- pnpm (recommended) or npm

### 1. Clone and Setup
```bash
git clone https://github.com/adrianstanca1/Asagents.git
cd Asagents
pnpm install
```

### 2. Environment Configuration
```bash
cp .env.example .env.local
```

Edit `.env.local` with your values:
```env
# Required
AUTH_SECRET=your-generated-secret-here
XAI_API_KEY=your-xai-api-key-here

# Optional (comment out if not needed)
# POSTGRES_URL=your-postgres-url
# BLOB_READ_WRITE_TOKEN=your-blob-token
# REDIS_URL=your-redis-url
```

### 3. Build
```bash
pnpm build
```

### 4. Deploy Options

#### Option A: Vercel CLI
```bash
npm i -g vercel
vercel login
vercel --prod
```

#### Option B: Other Platforms
The built application in `.next` folder can be deployed to any Node.js hosting platform:
- Netlify
- Railway
- DigitalOcean App Platform
- AWS Amplify
- Docker

#### Option C: Run Locally
```bash
# Development
pnpm dev

# Production
pnpm start
```

## 🔧 Build Features

- **No Database Required**: The application builds and runs without requiring a database connection
- **Local Fonts**: Uses local Geist fonts for offline support
- **Conditional Migrations**: Database migrations are skipped if POSTGRES_URL is not provided
- **Edge Runtime Compatible**: Optimized for serverless deployment

## 🏗️ Architecture

- **Framework**: Next.js 15 with App Router
- **AI SDK**: Vercel AI SDK with xAI integration
- **Styling**: Tailwind CSS with shadcn/ui components
- **Database**: Optional Neon Serverless Postgres
- **Authentication**: Auth.js (NextAuth v5)
- **File Storage**: Optional Vercel Blob

## 🚨 Troubleshooting

### Build Issues
- If build fails with database errors, ensure `POSTGRES_URL` is commented out or undefined
- Set `SKIP_MIGRATIONS=true` to explicitly skip database migrations

### Runtime Issues
- Authentication will work with guest mode if no database is configured
- File uploads require `BLOB_READ_WRITE_TOKEN`
- AI features require `XAI_API_KEY`

### Font Issues
- The app uses local Geist fonts - no internet connection required for fonts
- If font errors occur, verify the `geist` package is installed

## 📈 Monitoring

Once deployed, monitor your application:
- Check Vercel Analytics (if using Vercel)
- Monitor OpenTelemetry traces (configured with Vercel OTEL)
- Review logs for any runtime errors

## 🔒 Security Notes

- Never commit your `.env.local` file
- Use strong, randomly generated AUTH_SECRET
- Rotate API keys regularly
- Enable Vercel's security features if using Vercel

## 📚 Additional Resources

- [Next.js Deployment Docs](https://nextjs.org/docs/deployment)
- [Vercel Deployment Guide](https://vercel.com/docs)
- [xAI API Documentation](https://docs.x.ai/)
- [Project Setup Guide](./SETUP.md)