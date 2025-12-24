# Backend API

Express.js REST API with TypeScript.

## Structure

- `src/controllers/` - HTTP request handlers
- `src/services/` - Business logic (Reddit, AI, etc.)
- `src/models/` - Database models
- `src/workers/` - Background job processors
- `src/middleware/` - Express middleware (auth, validation)
- `src/routes/` - API route definitions
- `src/utils/` - Helper functions
- `src/config/` - Configuration files
- `src/types/` - TypeScript type definitions
- `tests/` - Unit and integration tests

## Tech Stack

- Node.js 18+ (runtime)
- Express.js (web framework)
- TypeScript (type safety)
- Bull (job queue)
- Joi (validation)
- JWT (authentication)