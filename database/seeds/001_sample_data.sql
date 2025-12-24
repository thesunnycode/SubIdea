-- =====================================================
-- Sample Data for Development
-- Seed: 001_sample_data.sql
-- =====================================================

-- Insert sample user
INSERT INTO users (email, name, avatar_url, provider, provider_id, skill_level)
VALUES
  ('test@example.com', 'Test User', 'https://i.pravatar.cc/150?img=1', 'github', 'test123', 'intermediate');

-- Get user ID for reference
DO $$
DECLARE
  test_user_id UUID;
BEGIN
  SELECT id INTO test_user_id FROM users WHERE email = 'test@example.com';

  -- Insert sample Reddit post
  INSERT INTO reddit_posts (reddit_id, subreddit, title, content, author, url, score, num_comments, created_at)
  VALUES
    ('abc123', 'Entrepreneur', 'I spend 3 hours daily managing my tasks across 5 different apps',
     'It''s getting ridiculous. I use Notion for notes, Todoist for tasks, Google Calendar, Slack, and Trello. Wish there was one place...',
     'frustrated_founder', 'https://reddit.com/r/Entrepreneur/comments/abc123',
     234, 56, NOW() - INTERVAL '2 days');

  -- Insert sample problem
  INSERT INTO problems (title, description, domain, sentiment_score, urgency_score, frequency_count, source_posts, status)
  VALUES
    ('Too many productivity apps causing inefficiency',
     'Users struggle to manage tasks across multiple productivity tools, leading to time waste and frustration.',
     'productivity',
     -0.72,
     85,
     12,
     '[{"reddit_id": "abc123", "subreddit": "Entrepreneur"}]'::jsonb,
     'analyzed')
  RETURNING id INTO test_user_id; -- Reuse variable

  -- Insert sample project
  INSERT INTO projects (
    problem_id, title, description, features, tech_stack,
    difficulty_level, implementation_roadmap, estimated_hours, monetization_potential
  )
  VALUES (
    test_user_id,
    'Unified Productivity Dashboard',
    'A centralized platform that integrates multiple productivity tools into a single dashboard with smart task prioritization.',
    '["OAuth integration with 10+ productivity apps", "Unified task view across all platforms", "AI-powered task prioritization", "Cross-app analytics", "One-click task creation"]'::jsonb,
    '{"frontend": ["Next.js", "TypeScript", "Tailwind CSS"], "backend": ["Node.js", "Express"], "database": ["PostgreSQL", "Redis"], "apis": ["Todoist API", "Notion API", "Google Calendar API"]}'::jsonb,
    'intermediate',
    '[{"phase": 1, "title": "Setup & OAuth Integration", "duration": "1 week", "tasks": ["Setup Next.js project", "Implement OAuth for 3 services", "Design database schema"]}]'::jsonb,
    80,
    'high'
  );

END $$;