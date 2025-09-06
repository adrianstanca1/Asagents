import { config } from 'dotenv';
import { drizzle } from 'drizzle-orm/postgres-js';
import { migrate } from 'drizzle-orm/postgres-js/migrator';
import postgres from 'postgres';

config({
  path: '.env.local',
});

const runMigrate = async () => {
  // Skip migrations if explicitly disabled or if POSTGRES_URL is not provided
  if (process.env.SKIP_MIGRATIONS === 'true') {
    console.log('🔄 Skipping migrations (SKIP_MIGRATIONS=true)');
    process.exit(0);
  }

  if (!process.env.POSTGRES_URL) {
    console.log('⚠️  POSTGRES_URL is not defined - skipping migrations');
    console.log('💡 Set POSTGRES_URL environment variable to run migrations');
    console.log('💡 Set SKIP_MIGRATIONS=true to explicitly skip this step');
    process.exit(0);
  }

  const connection = postgres(process.env.POSTGRES_URL, { max: 1 });
  const db = drizzle(connection);

  console.log('⏳ Running migrations...');

  const start = Date.now();
  await migrate(db, { migrationsFolder: './lib/db/migrations' });
  const end = Date.now();

  console.log('✅ Migrations completed in', end - start, 'ms');
  process.exit(0);
};

runMigrate().catch((err) => {
  console.error('❌ Migration failed');
  console.error(err);
  process.exit(1);
});
