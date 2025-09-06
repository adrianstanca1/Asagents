# Asagents - Setup Guide

## Quick Start (No Database Required)

The application can now run without requiring a database connection. This guide shows how to get the application running quickly for development or testing.

### Prerequisites

- Node.js 18+ 
- pnpm (or npm/yarn)

### Installation

1. **Install dependencies:**
   ```bash
   pnpm install
   ```

2. **Create environment file:**
   ```bash
   cp .env.example .env.local
   ```
   
   **Note:** You can leave `POSTGRES_URL` commented out or undefined. The application will skip database migrations and build successfully.

3. **Build the application:**
   ```bash
   pnpm build
   ```

4. **Run in development mode:**
   ```bash
   pnpm dev
   ```

5. **Run in production mode:**
   ```bash
   pnpm start
   ```

## Key Features

✅ **Conditional Database Migrations:** Build process no longer requires database connection  
✅ **Local Font Support:** Uses local Geist fonts instead of Google Fonts for offline support  
✅ **Development Ready:** Start coding immediately without database setup  
✅ **Production Ready:** Can be built and deployed without external dependencies  

## Database Setup (Optional)

If you want to use the full features with persistent data:

1. Set up a PostgreSQL database
2. Add `POSTGRES_URL` to your `.env.local` file
3. Run migrations: `pnpm db:migrate`

## Environment Variables

### Required (with defaults)
- `AUTH_SECRET` - Authentication secret key
- `XAI_API_KEY` - xAI API key for chat functionality

### Optional  
- `POSTGRES_URL` - Database connection (skip for development without persistence)
- `BLOB_READ_WRITE_TOKEN` - File upload support
- `REDIS_URL` - Caching (optional)

## Scripts

- `pnpm dev` - Start development server
- `pnpm build` - Build for production  
- `pnpm start` - Start production server
- `pnpm lint` - Run linting
- `pnpm db:migrate` - Run database migrations (when database is available)

## Troubleshooting

### Build Fails with Database Connection Error
- Ensure `POSTGRES_URL` is commented out in `.env.local` 
- Or set `SKIP_MIGRATIONS=true` in your environment

### Font Loading Issues
- The app now uses local Geist fonts - no internet connection required
- If you see font-related errors, check that the `geist` package is installed

### Authentication Errors at Runtime
- Without database, authentication will fail but the app will still start
- This is expected behavior for development without persistence
- Set up database connection for full authentication support