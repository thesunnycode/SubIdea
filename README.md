# SubIdea - Project Setup Documentation

> **For**: MCA Students and Developers  
> **Created**: January 2025  
> **Status**: Phase 0 - Setup Complete ✅

---

## 📋 Project Overview

**Name**: SubIdea  
**Description**: AI-Powered Problem Discovery & Project Generator Platform  
**Purpose**: Help students and developers find validated project ideas from real Reddit discussions

### Tech Stack Decision

| Component | Technology | Why? |
|-----------|-----------|------|
| **Frontend** | Next.js 14 + TypeScript | Modern React framework, great for SEO, student-friendly |
| **Backend** | Node.js + Express | JavaScript everywhere, huge community support |
| **Database** | PostgreSQL (Supabase) | Free tier, built-in auth, pgvector support |
| **AI** | Google Gemini Pro | You have subscription, $0 cost |
| **Embeddings** | OpenAI text-embedding-3-small | Cheap (~$0.50/month), reliable |
| **Caching** | Redis (Upstash) | Free tier, job queue support |
| **Auth** | GitHub OAuth (NextAuth.js) | No password management needed |

---

## 🎯 Project Goals

### Primary Goals
1. ✅ Learn modern full-stack development
2. ✅ Build portfolio-worthy project
3. ✅ Integrate AI APIs (Gemini)
4. ✅ Practice database design
5. ✅ Deploy real application

### Learning Outcomes
- Modern web development (React, Next.js, TypeScript)
- Backend API design (Express, REST)
- Database design (PostgreSQL, migrations)
- AI integration (Gemini API, embeddings)
- Authentication (OAuth 2.0)
- Background jobs (Bull queue)
- Deployment (Vercel, Railway)

---

## 📂 Project Structure

- **frontend/** – Next.js application  
- **backend/** – Express API  
- **database/** – SQL migrations & seeds  
- **docs/** – Documentation & wireframes  
- **scripts/** – Utility scripts  
- **.env.master** – All API keys (DO NOT COMMIT)



All secrets stored in `.env.master` (excluded from Git).

### Required API Keys
1. ✅ Supabase Database URL
2. ✅ Google Gemini API Key
3. ✅ OpenAI API Key (embeddings)
4. ✅ Reddit API Credentials
5. ✅ GitHub OAuth App
6. ✅ Upstash Redis URL

---

## 🗄️ Database Schema

### Tables
1. **users** - User accounts (GitHub OAuth)
2. **reddit_posts** - Raw scraped posts
3. **problems** - Analyzed problems with AI scores
4. **projects** - Generated project specifications
5. **user_bookmarks** - Saved projects with progress
6. **problem_analytics** - Trending data over time

### Special Features
- **pgvector**: Enables AI similarity search
- **Full-text search**: Fast keyword search
- **Triggers**: Auto-update timestamps

See `database/migrations/001_initial_schema.sql` for complete schema.

---

## 🎨 Design (Wireframes)

Wireframes created in Excalidraw:
- Homepage: `docs/wireframes/homepage.png`
- Problems List: `docs/wireframes/problems-list.png`
- Problem Detail: `docs/wireframes/problem-detail.png`
- Project View: `docs/wireframes/project-view.png`
- User Dashboard: `docs/wireframes/user-dashboard.png`

---

## 🌐 API Endpoints

Complete API documentation: `docs/API_ENDPOINTS.md`

### Main Endpoints
- `GET /api/problems` - Browse problems
- `POST /api/projects/generate` - Generate project with AI
- `POST /api/bookmarks` - Save project
- `GET /api/user/profile` - User profile

---

## 📊 Development Timeline

### Phase 0: Setup (Week 1) ✅
- [x] Environment setup
- [x] Database design
- [x] Wireframes created
- [x] API endpoints defined
- [x] Project structure organized

### Phase 1: Backend (Weeks 2-3)
- [ ] Reddit scraper
- [ ] AI analysis with Gemini
- [ ] Database integration
- [ ] REST API implementation

### Phase 2: Frontend (Weeks 4-5)
- [ ] Next.js setup
- [ ] UI components
- [ ] Problem browsing
- [ ] Project generation UI

### Phase 3: User Features (Week 6)
- [ ] Authentication
- [ ] Bookmarks
- [ ] User dashboard

### Phase 4: Polish & Deploy (Week 7-8)
- [ ] Testing
- [ ] Performance optimization
- [ ] Deployment

---

## 🚀 Next Steps (Phase 1)

1. Initialize Next.js project
2. Initialize Express project
3. Setup TypeScript configuration
4. Configure linters (ESLint, Prettier)
5. First commit to GitHub

---

## 📚 Resources

### Learning Resources
- Next.js Docs: https://nextjs.org/docs
- TypeScript Handbook: https://www.typescriptlang.org/docs/
- PostgreSQL Tutorial: https://www.postgresqltutorial.com/
- Gemini API Docs: https://ai.google.dev/docs

### Tools
- Supabase Dashboard: https://app.supabase.com/
- Upstash Console: https://console.upstash.com/
- GitHub Repository: [Your Repo URL]

---

## ⚠️ Important Notes

1. **Never commit `.env` files** to Git
2. **Always test locally** before pushing to production
3. **Keep API keys secret** - don't share screenshots with keys
4. **Monitor API costs** - check usage daily (first month)
5. **Backup database** - export data weekly

---

## 🐛 Known Issues / Limitations

None yet - this is Phase 0!

---

## 👥 Team

- Developer: Sunny Kr Singh
- Purpose: MCA Project / Portfolio
- Contact: 

---

## 📝 License

MIT License - Open source, free to use

---

**Last Updated**: [Current Date]  
**Phase**: 0 - Setup Complete ✅