-- =====================================================
-- SubIdea Database Schema
-- Migration: 001_initial_schema.sql
-- Created: 2025-12-24
-- =====================================================


-- Enable UUID extension(for generating unique IDs)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enable pgvector extension (for AI similarity search)
CREATE EXTENSION IF NOT EXISTS vector;

-- =====================================================
-- Table: users
-- Purpose: Store user accounts (GitHub OAuth)
-- =====================================================

CREATE TABLE users(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    avatar_url TEXT,
    provider VARCHAR(50) NOT NULL DEFAULT 'github',
    provider_id VARCHAR(255) NOT NULL,
    skill_level VARCHAR(20) DEFAULT 'beginner' CHECK (skill_level IN ('beginner','intermediate','advanced') ),
    preferred_tech_stack JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE (provider,provider_id)
);

-- Index for faster email lookups
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_skill_level ON users(skill_level);

-- =====================================================
-- Table: reddit_posts
-- Purpose: Store raw posts scraped from Reddit
-- =====================================================

CREATE TABLE reddit_posts(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reddit_id VARCHAR(50) UNIQUE NOT NULL,
    subreddit VARCHAR(100) NOT NULL,
    title TEXT NOT NULL,
    content TEXT,
    author VARCHAR(100),
    url TEXT,
    score INTEGER DEFAULT 0,
    num_comments INTEGER DEFAULT 0,
    created_at TIMESTAMP NOT NULL,
    scraped_at TIMESTAMP DEFAULT NOW()
);


CREATE UNIQUE INDEX idx_reddit_posts_reddit_id on reddit_posts(reddit_id);
CREATE INDEX idx_reddit_posts_subreddit ON reddit_posts(subreddit);
CREATE INDEX idx_reddit_posts_created_at ON reddit_posts(created_at DESC);

-- =====================================================
-- Table: problems
-- Purpose: Analyzed and scored problems
-- =====================================================

CREATE TABLE problems(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(500) NOT NULL,
    description TEXT NOT NULL,
    domain VARCHAR(100) NOT NULL,
    sentiment_score DECIMAL(3,2) DEFAULT 0.0 CHECK (sentiment_score >= -1 AND sentiment_score <=1),
    urgency_score INTEGER DEFAULT 0 CHECK(urgency_score >=0 AND urgency_score <=100),
    frequency_count INTEGER DEFAULT 1,
    embedding vector(768),
    source_posts JSONB DEFAULT '[]'::jsonb,
    status VARCHAR(50) DEFAULT 'new' CHECK(status IN('new','analyzed','project_generated')),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_problems_domain on problems(domain);
CREATE INDEX idx_problem_urgency ON problems(urgency_score DESC);
CREATE INDEX idx_problem_status ON problems(status);
CREATE INDEX idx_problems_created_at ON problems(created_at DESC);

-- Vector index for similarity search (IVFFlat algorithm)
CREATE INDEX idx_problems_embedding ON problems USING ivfflat(embedding vector_cosine_ops)
    WITH(lists=100);

-- Full-text search index
CREATE INDEX idx_problems_fts ON problems USING GIN(
    to_tsvector('english',title||' '|| description)
);

-- =====================================================
-- Table: projects
-- Purpose: AI-generated project specifications
-- =====================================================

CREATE TABLE projects(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    problem_id uuid NOT NULL REFERENCES problems(id) on DELETE CASCADE,
    title VARCHAR(500) NOT NULL,
    description TEXT NOT NULL,
    features JSONB NOT NULL,
    tech_stack JSONB NOT NULL,
    difficulty_level VARCHAR(20) NOT NULL CHECK (difficulty_level IN('beginner','intermediate','advanced')),
    implementation_roadmap JSONB NOT NULL,
    estimated_hours INTEGER,
    monetization_potential VARCHAR(20) CHECK ( monetization_potential IN ('low','medium','high') ),
    wireframes_description TEXT,
    generated_at TIMESTAMP default NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_projects_problem_id ON projects(problem_id);
CREATE INDEX idx_projects_difficulty ON projects(difficulty_level);
CREATE INDEX idx_projects_generated_at ON projects(generated_at DESC);


-- =====================================================
-- Table: user_bookmarks
-- Purpose: User's saved projects with progress tracking
-- =====================================================

CREATE TABLE user_bookmarks(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'saved' CHECK (status IN ('saved','started','in_progress','completed')),
    progress_percentage INTEGER DEFAULT 0 CHECK (progress_percentage>=0 AND progress_percentage<=100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id,project_id)
);

-- Indexes
CREATE INDEX idx_bookmarks_user_id ON user_bookmarks(user_id);
CREATE INDEX idx_bookmarks_status On user_bookmarks(status);
CREATE INDEX idx_bookmarks_created_at ON user_bookmarks(created_at DESC);

-- =====================================================
-- Table: problem_analytics
-- Purpose: Track problem trends over time
-- =====================================================
CREATE TABLE problem_analytics(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    problem_id UUID NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    mention_count INTEGER DEFAULT 0,
    avg_sentiment DECIMAL(3,2) DEFAULT 0.0,
    engagement_score DECIMAL(5,2) DEFAULT 0.0,
    UNIQUE(problem_id,date)
);

--Index
CREATE INDEX idx_analytics_problem_date ON problem_analytics(problem_id,date DESC);

-- =====================================================
-- Functions & Triggers
-- =====================================================

-- Function to update updated_at timestamp automatically

CREATE OR REPLACE FUNCTION update_updated_at_column()
       RETURNS TRIGGER AS $$
       BEGIN
         NEW.updated_at=NOW();
         RETURN NEW;
       END;
       $$ LANGUAGE plpgsql;

-- Apply trigger to all tables with updated_at

CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_problems_updated_at
    BEFORE UPDATE ON problems
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_projects_updated_at
    BEFORE UPDATE ON projects
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_bookmarks_updated_at
    BEFORE UPDATE ON user_bookmarks
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- Initial seed data (for testing)
-- =====================================================

-- Sample domains for categorization
COMMENT ON COLUMN problems.domain IS 'Valid domains: productivity, communication, finance, health, education, e-commerce, saas, developer-tools, marketing, automation, data-management, other';

-- =====================================================
-- Schema complete!
-- =====================================================























