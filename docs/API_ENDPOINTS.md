# SubIdea API Endpoints Documentation

## Base URLs
- Development: `http://localhost:4000/api`
- Production: `https://api.subidea.com/api` (future)

---

## Authentication

All endpoints marked with 🔒 require authentication via JWT token:
## 1. Authentication Endpoints

### `POST /auth/github`
**Description**: Initiate GitHub OAuth login

**Request Body**: None (redirects to GitHub)

**Response**: Redirect to GitHub OAuth page

---

### `GET /auth/callback/github`
**Description**: GitHub OAuth callback

**Query Parameters**:
- `code` (string, required): OAuth authorization code
- `state` (string, required): CSRF token

**Response**: 200 OK
```json
{
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "John Doe",
    "avatar_url": "https://..."
  },
  "token": "eyJhbGciOiJIUzI1NiIs..."
}
### `POST /auth/logout` 🔒
**Description**: Logout current user

**Response**: 200 OK
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

---

## 2. Problems Endpoints

### `GET /problems`
**Description**: Get list of discovered problems

**Query Parameters**:
- `page` (number, default: 1): Page number
- `limit` (number, default: 20, max: 100): Items per page
- `domain` (string, optional): Filter by domain (e.g., "productivity")
- `min_urgency` (number, 0-100, optional): Minimum urgency score
- `sort` (string, default: "trending"): Sort method
  - Options: `trending`, `recent`, `urgent`, `popular`
- `search` (string, optional): Full-text search query

**Response**: 200 OK
```json
{
  "problems": [
    {
      "id": "uuid-123",
      "title": "Too many productivity apps causing inefficiency",
      "description": "Users struggle to manage tasks...",
      "domain": "productivity",
      "sentiment_score": -0.72,
      "urgency_score": 85,
      "frequency_count": 12,
      "created_at": "2025-01-15T10:00:00Z",
      "source_post_count": 5
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "total_pages": 8
  }
}
```

---

### `GET /problems/:id`
**Description**: Get detailed information about a specific problem

**Path Parameters**:
- `id` (uuid, required): Problem ID

**Response**: 200 OK
```json
{
  "problem": {
    "id": "uuid-123",
    "title": "Too many productivity apps...",
    "description": "Full description here...",
    "domain": "productivity",
    "urgency_score": 85,
    "frequency_count": 12,
    "sentiment_score": -0.72,
    "created_at": "2025-01-15T10:00:00Z"
  },
  "related_posts": [
    {
      "reddit_id": "abc123",
      "subreddit": "Entrepreneur",
      "title": "Reddit post title",
      "url": "https://reddit.com/r/Entrepreneur/...",
      "score": 234,
      "num_comments": 56
    }
  ],
  "analytics": {
    "trend": "rising",
    "weekly_growth": 45.2,
    "mention_history": [
      {"date": "2025-01-08", "count": 5},
      {"date": "2025-01-15", "count": 12}
    ]
  }
}
```

---

## 3. Projects Endpoints

### `POST /projects/generate` 🔒
**Description**: Generate project from problem using AI

**Rate Limit**: 5 requests/hour per user

**Request Body**:
```json
{
  "problem_id": "uuid-123",
  "difficulty_preference": "intermediate"
}
```

**Response**: 202 Accepted (Streaming)
```json
{
  "project": {
    "id": "proj-uuid",
    "problem_id": "uuid-123",
    "title": "Unified Productivity Dashboard",
    "description": "A centralized platform...",
    "features": [
      "OAuth integration with 10+ apps",
      "Unified task view",
      "AI-powered prioritization"
    ],
    "tech_stack": {
      "frontend": ["Next.js", "TypeScript", "Tailwind CSS"],
      "backend": ["Node.js", "Express"],
      "database": ["PostgreSQL", "Redis"]
    },
    "difficulty_level": "intermediate",
    "implementation_roadmap": [
      {
        "phase": 1,
        "title": "Setup & OAuth",
        "duration": "1 week",
        "tasks": ["Setup project", "Implement OAuth"]
      }
    ],
    "estimated_hours": 80,
    "monetization_potential": "high",
    "generated_at": "2025-01-15T14:30:00Z"
  }
}
```

**Error**: 429 Too Many Requests
```json
{
  "error": "Rate limit exceeded",
  "message": "You can generate 5 projects per hour. Try again in 45 minutes.",
  "retry_after": 2700
}
```

---

### `GET /projects`
**Description**: Browse generated projects

**Query Parameters**:
- `page`, `limit`, `sort`: Same as problems
- `difficulty` (string, optional): Filter by difficulty
- `tech` (string, optional): Filter by technology
- `domain` (string, optional): Filter by problem domain
- `monetizable` (boolean, optional): Only high monetization potential

**Response**: 200 OK
```json
{
  "projects": [
    {
      "id": "proj-uuid",
      "title": "Unified Productivity Dashboard",
      "description": "...",
      "difficulty_level": "intermediate",
      "estimated_hours": 80,
      "tech_stack": {...},
      "problem": {
        "id": "uuid-123",
        "title": "Too many productivity apps",
        "urgency_score": 85
      },
      "bookmark_count": 24,
      "generated_at": "2025-01-15T14:30:00Z"
    }
  ],
  "pagination": {...}
}
```

---

### `GET /projects/:id`
**Description**: Get full project details

**Response**: 200 OK
```json
{
  "project": {
    "id": "proj-uuid",
    "problem_id": "uuid-123",
    "title": "Unified Productivity Dashboard",
    "description": "Full description...",
    "features": [...],
    "tech_stack": {...},
    "difficulty_level": "intermediate",
    "implementation_roadmap": [...],
    "estimated_hours": 80,
    "monetization_potential": "high",
    "wireframes_description": "Main dashboard with...",
    "generated_at": "2025-01-15T14:30:00Z"
  },
  "problem": {
    "id": "uuid-123",
    "title": "Too many productivity apps",
    "urgency_score": 85
  },
  "similar_projects": [
    {
      "id": "proj-uuid-2",
      "title": "Task Aggregator App",
      "difficulty_level": "beginner"
    }
  ],
  "is_bookmarked": false
}
```

---

## 4. Bookmarks Endpoints

### `POST /bookmarks` 🔒
**Description**: Bookmark a project

**Request Body**:
```json
{
  "project_id": "proj-uuid"
}
```

**Response**: 201 Created
```json
{
  "bookmark": {
    "id": "bookmark-uuid",
    "user_id": "user-uuid",
    "project_id": "proj-uuid",
    "status": "saved",
    "progress_percentage": 0,
    "notes": null,
    "created_at": "2025-01-15T15:00:00Z"
  }
}
```

---

### `GET /bookmarks` 🔒
**Description**: Get user's bookmarked projects

**Query Parameters**:
- `status` (string, optional): Filter by status
  - Options: `saved`, `started`, `in_progress`, `completed`
- `sort` (string, default: "recent"): Sort method
  - Options: `recent`, `oldest`, `progress`

**Response**: 200 OK
```json
{
  "bookmarks": [
    {
      "id": "bookmark-uuid",
      "status": "in_progress",
      "progress_percentage": 60,
      "notes": "Completed frontend, working on backend APIs",
      "created_at": "2025-01-10T10:00:00Z",
      "updated_at": "2025-01-15T12:00:00Z",
      "project": {
        "id": "proj-uuid",
        "title": "Unified Productivity Dashboard",
        "difficulty_level": "intermediate"
      }
    }
  ],
  "stats": {
    "total": 15,
    "saved": 8,
    "started": 4,
    "in_progress": 2,
    "completed": 1
  }
}
```

---

### `PATCH /bookmarks/:id` 🔒
**Description**: Update bookmark status/notes

**Request Body**:
```json
{
  "status": "completed",
  "progress_percentage": 100,
  "notes": "Successfully deployed to Vercel!"
}
```

**Response**: 200 OK
```json
{
  "bookmark": {
    "id": "bookmark-uuid",
    "status": "completed",
    "progress_percentage": 100,
    "notes": "Successfully deployed to Vercel!",
    "updated_at": "2025-01-15T16:00:00Z"
  }
}
```

---

### `DELETE /bookmarks/:id` 🔒
**Description**: Remove a bookmark

**Response**: 204 No Content

---

## 5. Search Endpoints

### `GET /search`
**Description**: Global search across problems and projects

**Query Parameters**:
- `q` (string, required): Search query
- `type` (string, default: "all"): Search scope
  - Options: `problems`, `projects`, `all`
- `difficulty` (string, optional): Filter projects by difficulty
- `domain` (string, optional): Filter by domain

**Response**: 200 OK
```json
{
  "results": {
    "problems": [
      {
        "id": "uuid",
        "title": "...",
        "description": "...",
        "relevance_score": 0.92
      }
    ],
    "projects": [
      {
        "id": "uuid",
        "title": "...",
        "description": "...",
        "relevance_score": 0.88
      }
    ]
  },
  "total_results": 25,
  "query": "productivity saas"
}
```

---

## 6. User Endpoints

### `GET /user/profile` 🔒
**Description**: Get authenticated user's profile

**Response**: 200 OK
```json
{
  "user": {
    "id": "user-uuid",
    "email": "user@example.com",
    "name": "John Doe",
    "avatar_url": "https://...",
    "skill_level": "intermediate",
    "preferred_tech_stack": {
      "frontend": ["React", "TypeScript"],
      "backend": ["Node.js"],
      "database": ["PostgreSQL"]
    },
    "created_at": "2025-01-01T00:00:00Z",
    "stats": {
      "bookmarks_count": 15,
      "projects_generated": 8,
      "projects_completed": 2
    }
  }
}
```

---

### `PATCH /user/profile` 🔒
**Description**: Update user profile

**Request Body**:
```json
{
  "skill_level": "advanced",
  "preferred_tech_stack": {
    "frontend": ["Next.js", "TypeScript", "Tailwind CSS"],
    "backend": ["Node.js", "Python"],
    "database": ["PostgreSQL", "MongoDB"]
  }
}
```

**Response**: 200 OK
```json
{
  "user": {
    "id": "user-uuid",
    "skill_level": "advanced",
    "preferred_tech_stack": {...},
    "updated_at": "2025-01-15T17:00:00Z"
  }
}
```

---

## Error Responses

All errors follow this format:

```json
{
  "error": "Error Title",
  "message": "Detailed error message",
  "code": "ERROR_CODE",
  "status": 400
}
```

### Common Error Codes

| Status | Code | Description |
|--------|------|-------------|
| 400 | VALIDATION_ERROR | Invalid request body/params |
| 401 | UNAUTHORIZED | Missing or invalid token |
| 403 | FORBIDDEN | Insufficient permissions |
| 404 | NOT_FOUND | Resource doesn't exist |
| 429 | RATE_LIMIT_EXCEEDED | Too many requests |
| 500 | INTERNAL_SERVER_ERROR | Unexpected server error |
| 503 | SERVICE_UNAVAILABLE | External service down |

---

## Rate Limiting

| Endpoint | Limit | Window |
|----------|-------|--------|
| Any API (Unauthenticated) | 10 req | 1 minute |
| Any API (Authenticated) | 60 req | 1 minute |
| `/projects/generate` | 5 req | 1 hour |
| `/auth/*` | 5 req | 15 minutes |

**Rate Limit Headers**:
```
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 45
X-RateLimit-Reset: 1642349280
```

---

## Notes for Developers

1. **Authentication**: Store JWT token in localStorage or httpOnly cookie
2. **Pagination**: Always specify `limit` to control response size
3. **Error Handling**: Check status codes and handle errors gracefully
4. **Rate Limits**: Implement exponential backoff for retries
5. **Caching**: GET endpoints support ETag headers for caching

---

**Last Updated**: January 2025
**API Version**: 1.0.0
---