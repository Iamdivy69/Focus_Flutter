-- Initial Supabase Schema for FocusShield

-- users table
CREATE TABLE public.users (
    uid UUID REFERENCES auth.users NOT NULL PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    display_name TEXT,
    age INT,
    email TEXT,
    phone TEXT,
    profile_photo_url TEXT,
    xp_points INT DEFAULT 0,
    focus_level INT DEFAULT 0,
    current_streak INT DEFAULT 0,
    longest_streak INT DEFAULT 0,
    total_focus_minutes INT DEFAULT 0,
    is_minor BOOLEAN DEFAULT FALSE,
    fcm_token TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    last_active TIMESTAMPTZ DEFAULT NOW(),
    privacy_profile_public BOOLEAN DEFAULT TRUE,
    privacy_streak_visible BOOLEAN DEFAULT TRUE,
    privacy_stats_visible BOOLEAN DEFAULT TRUE,
    privacy_allow_requests BOOLEAN DEFAULT TRUE
);

-- friendships table
CREATE TABLE public.friendships (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_a_uid UUID REFERENCES public.users(uid) ON DELETE CASCADE,
    user_b_uid UUID REFERENCES public.users(uid) ON DELETE CASCADE,
    status TEXT NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (user_a_uid, user_b_uid)
);

-- friend_stats table
CREATE TABLE public.friend_stats (
    uid UUID REFERENCES public.users(uid) ON DELETE CASCADE PRIMARY KEY,
    xp_points INT DEFAULT 0,
    current_streak INT DEFAULT 0,
    last_active TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- leaderboard_weekly table
CREATE TABLE public.leaderboard_weekly (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    uid UUID REFERENCES public.users(uid) ON DELETE CASCADE,
    rank INT,
    xp_points INT,
    week_start TIMESTAMPTZ,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- daily_reports table
CREATE TABLE public.daily_reports (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    uid UUID REFERENCES public.users(uid) ON DELETE CASCADE,
    report_date DATE NOT NULL,
    total_focus_minutes INT DEFAULT 0,
    score INT,
    streak_count INT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (uid, report_date)
);

-- user_consents table
CREATE TABLE public.user_consents (
    uid UUID REFERENCES public.users(uid) ON DELETE CASCADE PRIMARY KEY,
    privacy_policy_accepted_at TIMESTAMPTZ,
    tos_accepted_at TIMESTAMPTZ,
    on_device_processing_accepted_at TIMESTAMPTZ,
    research_consent_accepted_at TIMESTAMPTZ
);

-- ai_usage_log table
CREATE TABLE public.ai_usage_log (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    uid UUID REFERENCES public.users(uid) ON DELETE CASCADE,
    date DATE NOT NULL,
    request_count INT DEFAULT 0,
    UNIQUE (uid, date)
);

-- model_versions table
CREATE TABLE public.model_versions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    version TEXT NOT NULL UNIQUE,
    is_active BOOLEAN DEFAULT FALSE,
    release_date TIMESTAMPTZ DEFAULT NOW(),
    bucket_path TEXT NOT NULL
);

-- Row Level Security (RLS) setup
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.friendships ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.friend_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.leaderboard_weekly ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.daily_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_consents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_usage_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.model_versions ENABLE ROW LEVEL SECURITY;

-- Basic RLS Policies
CREATE POLICY "Users can view public profiles" 
    ON public.users FOR SELECT 
    USING (privacy_profile_public = TRUE OR auth.uid() = uid);

CREATE POLICY "Users can update own profile" 
    ON public.users FOR UPDATE 
    USING (auth.uid() = uid);

CREATE POLICY "Users can insert own profile" 
    ON public.users FOR INSERT 
    WITH CHECK (auth.uid() = uid);

CREATE POLICY "Users can manage own friendships" 
    ON public.friendships FOR ALL 
    USING (auth.uid() = user_a_uid OR auth.uid() = user_b_uid);

CREATE POLICY "Users can view friend stats" 
    ON public.friend_stats FOR SELECT 
    USING (TRUE);

CREATE POLICY "Users can update own stats" 
    ON public.friend_stats FOR UPDATE 
    USING (auth.uid() = uid);

CREATE POLICY "Users can insert own stats" 
    ON public.friend_stats FOR INSERT 
    WITH CHECK (auth.uid() = uid);

CREATE POLICY "Public leaderboard view" 
    ON public.leaderboard_weekly FOR SELECT 
    USING (TRUE);

CREATE POLICY "Users can view own daily reports" 
    ON public.daily_reports FOR SELECT 
    USING (auth.uid() = uid);

CREATE POLICY "Users can manage own daily reports" 
    ON public.daily_reports FOR ALL 
    USING (auth.uid() = uid);

CREATE POLICY "Users can manage own consents" 
    ON public.user_consents FOR ALL 
    USING (auth.uid() = uid);

CREATE POLICY "Users can view own ai usage" 
    ON public.ai_usage_log FOR SELECT 
    USING (auth.uid() = uid);

CREATE POLICY "Model versions read only" 
    ON public.model_versions FOR SELECT 
    USING (TRUE);

-- Indexes
CREATE INDEX idx_users_username ON public.users(username);
CREATE INDEX idx_friendships_status ON public.friendships(status);
CREATE INDEX idx_leaderboard_week ON public.leaderboard_weekly(week_start);
CREATE INDEX idx_daily_reports_date ON public.daily_reports(uid, report_date);
