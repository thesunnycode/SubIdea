# Database

PostgreSQL database with pgvector extension.

## Structure

- `migrations/` - SQL schema changes (versioned)
- `seeds/` - Sample data for development

## Schema

See `migrations/001_initial_schema.sql` for complete schema.

### Tables
1. users - User accounts
2. reddit_posts - Raw Reddit data
3. problems - Analyzed problems
4. projects - Generated projects
5. user_bookmarks - Saved projects
6. problem_analytics - Trending data