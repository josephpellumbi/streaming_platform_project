-- ================================================================
-- STREAMING PLATFORM SQL PROJECT
-- Designed for DuckDB | Phases 1 through 4
-- ================================================================
--
-- TABLES:
--   users          → platform accounts
--   content        → movies and shows catalog
--   subscriptions  → plan history per user
--   watch_history  → individual viewing events
--
-- HOW TO USE:
--   Option A — DuckDB CLI:
--     1. Install DuckDB: https://duckdb.org/docs/installation
--     2. Open terminal and run: duckdb my_streaming.db
--     3. At the DuckDB prompt: .read streaming_platform_sql_project.sql
--        (or paste sections manually)
--
--   Option B — Python:
--     1. pip install duckdb
--     2. import duckdb
--        con = duckdb.connect('my_streaming.db')
--        con.execute(open('streaming_platform_sql_project.sql').read())
--
--   Option C — DBeaver (GUI):
--     1. Download DBeaver and create a DuckDB connection
--     2. Open this file and run sections as needed
--
--   Work through Phase 1 → 4, writing your queries below each
--   question. Hints are commented out below each one.
-- ================================================================


-- ================================================================
-- SECTION 1: SCHEMA
-- ================================================================

CREATE OR REPLACE TABLE users (
    user_id      INTEGER,
    full_name    VARCHAR,
    email        VARCHAR,
    signup_date  DATE,
    country      VARCHAR,
    age          INTEGER
);

CREATE OR REPLACE TABLE content (
    content_id        INTEGER,
    title             VARCHAR,
    genre             VARCHAR,
    content_type      VARCHAR,    -- 'movie' or 'show'
    release_year      INTEGER,
    duration_minutes  INTEGER,    -- for shows: avg episode runtime
    maturity_rating   VARCHAR     -- 'G', 'PG', 'PG-13', 'R', 'TV-14', 'TV-MA'
);

CREATE OR REPLACE TABLE subscriptions (
    subscription_id  INTEGER,
    user_id          INTEGER,
    plan_type        VARCHAR,     -- 'free', 'basic', 'premium'
    start_date       DATE,
    end_date         DATE,        -- NULL if currently active
    status           VARCHAR      -- 'active', 'cancelled', 'upgraded', 'downgraded'
);

CREATE OR REPLACE TABLE watch_history (
    watch_id             INTEGER,
    user_id              INTEGER,
    content_id           INTEGER,
    watch_date           DATE,
    watch_duration_mins  INTEGER,
    completed            BOOLEAN
);


-- ================================================================
-- SECTION 2: SAMPLE DATA
-- ================================================================

-- ---- users (20 rows) ----------------------------------------
INSERT INTO users VALUES
(1,  'Alice Monroe',    'alice@email.com',   DATE '2022-01-15', 'US', 29),
(2,  'Ben Carter',      'ben@email.com',     DATE '2022-02-03', 'US', 34),
(3,  'Carmen Diaz',     'carmen@email.com',  DATE '2022-02-20', 'MX', 26),
(4,  'David Kim',       'david@email.com',   DATE '2022-03-10', 'KR', 41),
(5,  'Eva Rossi',       'eva@email.com',     DATE '2022-04-05', 'IT', 31),
(6,  'Frank Nguyen',    'frank@email.com',   DATE '2022-04-22', 'US', 27),
(7,  'Grace Chen',      'grace@email.com',   DATE '2022-05-14', 'CN', 38),
(8,  'Hana Patel',      'hana@email.com',    DATE '2022-06-01', 'IN', 24),
(9,  'Ivan Petrov',     'ivan@email.com',    DATE '2022-06-18', 'RU', 45),
(10, 'Julia Santos',    'julia@email.com',   DATE '2022-07-07', 'BR', 33),
(11, 'Kevin Walsh',     'kevin@email.com',   DATE '2022-08-11', 'IE', 29),
(12, 'Lena Müller',     'lena@email.com',    DATE '2022-08-29', 'DE', 36),
(13, 'Marco Ferreira',  'marco@email.com',   DATE '2022-09-15', 'BR', 22),
(14, 'Nina Okafor',     'nina@email.com',    DATE '2022-10-03', 'NG', 30),
(15, 'Oscar Lindqvist', 'oscar@email.com',   DATE '2022-10-20', 'SE', 43),
(16, 'Priya Sharma',    'priya@email.com',   DATE '2022-11-08', 'IN', 28),
(17, 'Quinn Murphy',    'quinn@email.com',   DATE '2022-11-25', 'US', 35),
(18, 'Rosa Tanaka',     'rosa@email.com',    DATE '2022-12-12', 'JP', 27),
(19, 'Sam Osei',        'sam@email.com',     DATE '2023-01-09', 'GH', 31),
(20, 'Tara Novak',      'tara@email.com',    DATE '2023-01-30', 'CZ', 40);

-- ---- content (25 rows) --------------------------------------
INSERT INTO content VALUES
(1,  'Dark Waters',        'Thriller',    'movie', 2021, 118, 'PG-13'),
(2,  'The Lost City',      'Adventure',   'movie', 2020, 105, 'PG'),
(3,  'Mindscape',          'Sci-Fi',      'show',  2021, 45,  'TV-MA'),
(4,  'Laugh Track',        'Comedy',      'show',  2022, 30,  'PG'),
(5,  'Iron Coast',         'Drama',       'show',  2020, 55,  'TV-MA'),
(6,  'Galactic Run',       'Sci-Fi',      'movie', 2022, 130, 'PG-13'),
(7,  'The Quiet Storm',    'Drama',       'movie', 2019, 95,  'R'),
(8,  'Coral Reef',         'Documentary', 'movie', 2021, 88,  'G'),
(9,  'Neon Nights',        'Thriller',    'show',  2022, 42,  'TV-MA'),
(10, 'Family Chaos',       'Comedy',      'show',  2020, 25,  'PG'),
(11, 'Frozen North',       'Documentary', 'show',  2021, 50,  'G'),
(12, 'Pulse',              'Drama',       'show',  2022, 48,  'TV-MA'),
(13, 'The Heist',          'Thriller',    'movie', 2023, 112, 'R'),
(14, 'Wanderlust',         'Adventure',   'show',  2020, 35,  'PG'),
(15, 'Solar Winds',        'Sci-Fi',      'movie', 2021, 122, 'PG-13'),
(16, 'Open Roads',         'Drama',       'movie', 2022, 100, 'PG-13'),
(17, 'Comedy Central',     'Comedy',      'movie', 2019, 90,  'PG'),
(18, 'Deep Blue',          'Documentary', 'show',  2020, 44,  'G'),
(19, 'Blood Meridian',     'Thriller',    'show',  2021, 55,  'TV-MA'),
(20, 'Rise Up',            'Drama',       'show',  2022, 40,  'TV-14'),
(21, 'Robot Dreams',       'Sci-Fi',      'show',  2023, 38,  'PG-13'),
(22, 'Happy Endings',      'Comedy',      'show',  2021, 28,  'PG'),
(23, 'Wildfire Season',    'Documentary', 'movie', 2022, 75,  'G'),
(24, 'The Final Frontier', 'Sci-Fi',      'movie', 2020, 140, 'PG-13'),
(25, 'Midnight Express',   'Thriller',    'movie', 2023, 108, 'R');

-- ---- subscriptions (30 rows) --------------------------------
INSERT INTO subscriptions VALUES
(1,  1,  'free',    DATE '2022-01-15', DATE '2022-03-01', 'upgraded'),
(2,  1,  'basic',   DATE '2022-03-01', DATE '2022-07-15', 'upgraded'),
(3,  1,  'premium', DATE '2022-07-15', NULL,              'active'),
(4,  2,  'basic',   DATE '2022-02-03', DATE '2022-12-01', 'cancelled'),
(5,  2,  'free',    DATE '2022-12-01', DATE '2023-03-15', 'upgraded'),
(6,  2,  'basic',   DATE '2023-03-15', NULL,              'active'),
(7,  3,  'free',    DATE '2022-02-20', DATE '2022-06-01', 'upgraded'),
(8,  3,  'premium', DATE '2022-06-01', NULL,              'active'),
(9,  4,  'basic',   DATE '2022-03-10', DATE '2023-01-01', 'cancelled'),
(10, 5,  'premium', DATE '2022-04-05', NULL,              'active'),
(11, 6,  'free',    DATE '2022-04-22', DATE '2022-09-01', 'upgraded'),
(12, 6,  'basic',   DATE '2022-09-01', NULL,              'active'),
(13, 7,  'premium', DATE '2022-05-14', DATE '2023-02-01', 'cancelled'),
(14, 8,  'free',    DATE '2022-06-01', DATE '2022-10-15', 'upgraded'),
(15, 8,  'basic',   DATE '2022-10-15', NULL,              'active'),
(16, 9,  'basic',   DATE '2022-06-18', NULL,              'active'),
(17, 10, 'premium', DATE '2022-07-07', DATE '2023-04-01', 'cancelled'),
(18, 11, 'free',    DATE '2022-08-11', DATE '2023-01-01', 'upgraded'),
(19, 11, 'basic',   DATE '2023-01-01', NULL,              'active'),
(20, 12, 'premium', DATE '2022-08-29', NULL,              'active'),
(21, 13, 'free',    DATE '2022-09-15', NULL,              'active'),
(22, 14, 'basic',   DATE '2022-10-03', DATE '2023-03-01', 'cancelled'),
(23, 15, 'premium', DATE '2022-10-20', NULL,              'active'),
(24, 16, 'free',    DATE '2022-11-08', DATE '2023-05-01', 'upgraded'),
(25, 16, 'basic',   DATE '2023-05-01', NULL,              'active'),
(26, 17, 'basic',   DATE '2022-11-25', DATE '2023-02-15', 'upgraded'),
(27, 17, 'premium', DATE '2023-02-15', NULL,              'active'),
(28, 18, 'free',    DATE '2022-12-12', NULL,              'active'),
(29, 19, 'basic',   DATE '2023-01-09', NULL,              'active'),
(30, 20, 'premium', DATE '2023-01-30', DATE '2023-06-01', 'cancelled');

-- ---- watch_history (120 rows) --------------------------------
INSERT INTO watch_history VALUES
(1,   1,  6,  DATE '2022-08-01', 130, TRUE),
(2,   1,  3,  DATE '2022-08-03', 45,  TRUE),
(3,   1,  9,  DATE '2022-08-05', 42,  TRUE),
(4,   1,  3,  DATE '2022-08-07', 45,  TRUE),
(5,   1,  13, DATE '2022-09-01', 112, TRUE),
(6,   1,  15, DATE '2022-09-10', 122, TRUE),
(7,   1,  21, DATE '2023-01-05', 38,  TRUE),
(8,   1,  21, DATE '2023-01-07', 38,  TRUE),
(9,   2,  10, DATE '2022-03-01', 25,  TRUE),
(10,  2,  4,  DATE '2022-03-05', 30,  TRUE),
(11,  2,  17, DATE '2022-03-10', 90,  TRUE),
(12,  2,  10, DATE '2022-04-01', 25,  TRUE),
(13,  2,  22, DATE '2022-05-15', 28,  TRUE),
(14,  2,  1,  DATE '2022-06-20', 80,  FALSE),
(15,  2,  8,  DATE '2022-07-04', 88,  TRUE),
(16,  3,  5,  DATE '2022-07-01', 55,  TRUE),
(17,  3,  12, DATE '2022-07-10', 48,  TRUE),
(18,  3,  20, DATE '2022-08-01', 40,  TRUE),
(19,  3,  5,  DATE '2022-08-15', 55,  TRUE),
(20,  3,  7,  DATE '2022-09-01', 95,  TRUE),
(21,  3,  19, DATE '2022-10-01', 55,  TRUE),
(22,  4,  24, DATE '2022-04-01', 140, TRUE),
(23,  4,  15, DATE '2022-04-15', 122, TRUE),
(24,  4,  6,  DATE '2022-05-01', 130, TRUE),
(25,  4,  21, DATE '2022-06-01', 38,  TRUE),
(26,  4,  3,  DATE '2022-07-01', 30,  FALSE),
(27,  5,  12, DATE '2022-05-01', 48,  TRUE),
(28,  5,  20, DATE '2022-05-10', 40,  TRUE),
(29,  5,  5,  DATE '2022-06-01', 55,  TRUE),
(30,  5,  16, DATE '2022-07-01', 100, TRUE),
(31,  5,  7,  DATE '2022-08-01', 95,  TRUE),
(32,  5,  25, DATE '2023-01-15', 108, TRUE),
(33,  6,  4,  DATE '2022-05-01', 30,  TRUE),
(34,  6,  10, DATE '2022-05-10', 25,  TRUE),
(35,  6,  22, DATE '2022-06-01', 28,  TRUE),
(36,  6,  17, DATE '2022-07-01', 90,  TRUE),
(37,  6,  4,  DATE '2022-08-01', 30,  TRUE),
(38,  6,  10, DATE '2022-09-01', 25,  TRUE),
(39,  7,  3,  DATE '2022-06-01', 45,  TRUE),
(40,  7,  9,  DATE '2022-06-10', 42,  TRUE),
(41,  7,  19, DATE '2022-07-01', 55,  TRUE),
(42,  7,  1,  DATE '2022-08-01', 118, TRUE),
(43,  7,  13, DATE '2022-09-01', 112, TRUE),
(44,  8,  11, DATE '2022-07-01', 50,  TRUE),
(45,  8,  8,  DATE '2022-07-15', 88,  TRUE),
(46,  8,  18, DATE '2022-08-01', 44,  TRUE),
(47,  8,  23, DATE '2022-09-01', 75,  TRUE),
(48,  8,  11, DATE '2022-10-01', 50,  TRUE),
(49,  9,  1,  DATE '2022-07-01', 100, FALSE),
(50,  9,  13, DATE '2022-08-01', 112, TRUE),
(51,  9,  25, DATE '2022-09-01', 108, TRUE),
(52,  9,  19, DATE '2022-10-01', 55,  TRUE),
(53,  9,  9,  DATE '2022-11-01', 42,  TRUE),
(54,  10, 16, DATE '2022-08-01', 100, TRUE),
(55,  10, 7,  DATE '2022-08-15', 95,  TRUE),
(56,  10, 20, DATE '2022-09-01', 40,  TRUE),
(57,  10, 12, DATE '2022-10-01', 48,  TRUE),
(58,  10, 5,  DATE '2022-11-01', 55,  TRUE),
(59,  11, 4,  DATE '2022-09-01', 30,  TRUE),
(60,  11, 22, DATE '2022-09-15', 28,  TRUE),
(61,  11, 10, DATE '2022-10-01', 25,  TRUE),
(62,  11, 17, DATE '2022-11-01', 90,  TRUE),
(63,  12, 3,  DATE '2022-10-01', 45,  TRUE),
(64,  12, 21, DATE '2022-10-15', 38,  TRUE),
(65,  12, 6,  DATE '2022-11-01', 130, TRUE),
(66,  12, 15, DATE '2022-12-01', 122, TRUE),
(67,  12, 24, DATE '2023-01-01', 140, TRUE),
(68,  13, 4,  DATE '2022-10-01', 30,  TRUE),
(69,  13, 10, DATE '2022-10-15', 25,  TRUE),
(70,  13, 22, DATE '2022-11-01', 28,  TRUE),
(71,  14, 5,  DATE '2022-11-01', 55,  TRUE),
(72,  14, 12, DATE '2022-11-15', 48,  TRUE),
(73,  14, 20, DATE '2022-12-01', 40,  TRUE),
(74,  14, 7,  DATE '2022-12-15', 95,  TRUE),
(75,  15, 6,  DATE '2022-11-01', 130, TRUE),
(76,  15, 24, DATE '2022-11-15', 140, TRUE),
(77,  15, 15, DATE '2022-12-01', 122, TRUE),
(78,  15, 21, DATE '2023-01-01', 38,  TRUE),
(79,  15, 13, DATE '2023-02-01', 112, TRUE),
(80,  16, 11, DATE '2022-12-01', 50,  TRUE),
(81,  16, 8,  DATE '2022-12-15', 88,  TRUE),
(82,  16, 18, DATE '2023-01-01', 44,  TRUE),
(83,  16, 23, DATE '2023-02-01', 75,  TRUE),
(84,  17, 1,  DATE '2022-12-01', 118, TRUE),
(85,  17, 13, DATE '2022-12-15', 112, TRUE),
(86,  17, 25, DATE '2023-01-01', 108, TRUE),
(87,  17, 9,  DATE '2023-02-01', 42,  TRUE),
(88,  18, 10, DATE '2023-01-01', 25,  TRUE),
(89,  18, 4,  DATE '2023-01-15', 30,  TRUE),
(90,  18, 22, DATE '2023-02-01', 28,  TRUE),
(91,  19, 16, DATE '2023-02-01', 100, TRUE),
(92,  19, 7,  DATE '2023-02-15', 95,  TRUE),
(93,  19, 20, DATE '2023-03-01', 40,  TRUE),
(94,  19, 5,  DATE '2023-03-15', 55,  TRUE),
(95,  20, 3,  DATE '2023-02-01', 45,  TRUE),
(96,  20, 9,  DATE '2023-02-15', 42,  TRUE),
(97,  20, 19, DATE '2023-03-01', 55,  TRUE),
(98,  1,  24, DATE '2023-02-10', 140, TRUE),
(99,  2,  16, DATE '2023-04-01', 100, TRUE),
(100, 3,  25, DATE '2023-04-10', 108, TRUE),
(101, 4,  9,  DATE '2023-04-15', 42,  TRUE),
(102, 5,  3,  DATE '2023-04-20', 45,  TRUE),
(103, 6,  21, DATE '2023-04-25', 38,  TRUE),
(104, 7,  15, DATE '2023-05-01', 122, TRUE),
(105, 8,  21, DATE '2023-05-05', 38,  TRUE),
(106, 9,  6,  DATE '2023-05-10', 130, TRUE),
(107, 10, 24, DATE '2023-05-15', 140, TRUE),
(108, 11, 3,  DATE '2023-05-20', 45,  TRUE),
(109, 12, 9,  DATE '2023-05-25', 42,  TRUE),
(110, 13, 17, DATE '2023-05-28', 90,  TRUE),
(111, 14, 6,  DATE '2023-06-01', 130, TRUE),
(112, 15, 3,  DATE '2023-06-05', 45,  TRUE),
(113, 16, 6,  DATE '2023-06-10', 130, TRUE),
(114, 17, 24, DATE '2023-06-15', 140, TRUE),
(115, 18, 6,  DATE '2023-06-20', 130, TRUE),
(116, 19, 13, DATE '2023-06-25', 112, TRUE),
(117, 20, 13, DATE '2023-06-28', 112, TRUE),
(118, 1,  25, DATE '2023-06-30', 108, TRUE),
(119, 5,  13, DATE '2023-06-30', 112, TRUE),
(120, 10, 13, DATE '2023-06-30', 112, TRUE);


-- ================================================================
-- PHASE 1: FOUNDATIONS
-- Topics: SELECT, GROUP BY, HAVING, JOIN, aggregate functions
-- ================================================================

-- Q1.1
-- How many users signed up each month?
-- Return: signup_month, user_count. Order by month ascending.
--
-- HINT: DATE_TRUNC('month', signup_date) groups dates to their
--       first-of-month value in DuckDB. Use that in your GROUP BY.

-- [Your query here]


-- Q1.2
-- What is the total watch time (in minutes) per user?
-- Return: user_id, full_name, total_watch_mins.
-- Order by total_watch_mins descending.
--
-- HINT: JOIN users to watch_history on user_id, then SUM watch_duration_mins.

-- [Your query here]


-- Q1.3
-- What are the top 5 most-watched genres by total number of views?
-- Return: genre, total_views. Order by total_views descending.
--
-- HINT: JOIN watch_history to content, GROUP BY genre, then LIMIT 5.

-- [Your query here]


-- Q1.4
-- What is the completion rate (% of views that were completed) for each content type?
-- Return: content_type, total_views, completed_views, completion_rate.
-- Round completion_rate to 2 decimal places.
--
-- HINT: DuckDB supports the filter clause on aggregates:
--       COUNT(*) FILTER (WHERE completed = TRUE)
--       You can also use SUM(completed::INTEGER) to cast BOOLEAN to 0/1.

-- [Your query here]


-- Q1.5
-- Which users have watched more than 5 distinct pieces of content?
-- Return: user_id, full_name, distinct_titles_watched.
-- Order by distinct_titles_watched descending.
--
-- HINT: Use COUNT(DISTINCT content_id) and filter results with HAVING.

-- [Your query here]


-- ================================================================
-- PHASE 2: WINDOW FUNCTION BASICS
-- Topics: ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD, PARTITION BY
-- ================================================================

-- Q2.1
-- Rank all content titles by total number of views (most viewed = rank 1).
-- Use DENSE_RANK so that ties share a rank.
-- Return: title, genre, total_views, view_rank.
--
-- HINT: Aggregate total views per content_id in a CTE first,
--       then apply DENSE_RANK() OVER (ORDER BY total_views DESC)
--       in the outer query.

-- [Your query here]


-- Q2.2
-- For each user, find their most recently watched title.
-- Return: user_id, full_name, most_recent_title, watch_date.
--
-- HINT: Use ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY watch_date DESC).
--       Wrap it in a subquery or CTE and filter where row_num = 1.

-- [Your query here]


-- Q2.3
-- Within each country, rank users by their total watch time.
-- Return: country, full_name, total_watch_mins, country_rank.
-- Order by country, then country_rank.
--
-- HINT: Aggregate total watch time per user in a CTE, then apply
--       RANK() OVER (PARTITION BY country ORDER BY total_watch_mins DESC).

-- [Your query here]


-- Q2.4
-- For each user, calculate the number of days between each consecutive watch event.
-- Return: user_id, watch_date, days_since_last_watch.
-- For a user's first watch event, days_since_last_watch should be NULL.
-- Order by user_id, watch_date.
--
-- HINT: Use LAG(watch_date) OVER (PARTITION BY user_id ORDER BY watch_date)
--       to get the previous watch date. In DuckDB, subtracting two DATE values
--       directly returns an integer number of days:
--       watch_date - LAG(watch_date) OVER (...)

-- [Your query here]


-- Q2.5
-- For each genre, show each content title alongside the average watch duration
-- for that genre. How does each title compare to its genre average?
-- Return: genre, title, avg_watch_duration_mins (per title),
--         genre_avg_watch_mins, diff_from_genre_avg.
-- Round all averages to 2 decimal places.
--
-- HINT: Use AVG(watch_duration_mins) OVER (PARTITION BY genre) for the
--       genre-level average alongside a regular grouped AVG for the title average.
--       A CTE helps keep the two aggregations clean.

-- [Your query here]


-- ================================================================
-- PHASE 3: ROLLING WINDOWS & AGGREGATIONS
-- Topics: Window frames (ROWS BETWEEN), running totals,
--         rolling averages, monthly active users
-- ================================================================

-- Q3.1
-- For each user, calculate their cumulative (running) total watch minutes
-- ordered by watch_date.
-- Return: user_id, watch_date, watch_duration_mins, running_total_mins.
-- Order by user_id, watch_date.
--
-- HINT: SUM(watch_duration_mins) OVER (
--           PARTITION BY user_id ORDER BY watch_date
--           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
--       )

-- [Your query here]


-- Q3.2
-- For each user, calculate a rolling 3-session average watch duration
-- (current session + the 2 sessions before it).
-- Return: user_id, watch_date, watch_duration_mins, rolling_3_avg.
-- Round to 2 decimal places. Order by user_id, watch_date.
--
-- HINT: AVG(watch_duration_mins) OVER (
--           PARTITION BY user_id ORDER BY watch_date
--           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
--       )

-- [Your query here]


-- Q3.3
-- How many distinct active users watched content each month?
-- Return: watch_month, monthly_active_users. Order by watch_month ascending.
-- (An "active user" is any user with at least one watch event that month.)
--
-- HINT: DATE_TRUNC('month', watch_date) gives you the month bucket.
--       Use COUNT(DISTINCT user_id) to count active users per month.

-- [Your query here]


-- Q3.4
-- For each user, flag any watch session where their watch_duration_mins
-- was more than 1.5x their own personal average watch duration.
-- These could indicate a binge session worth investigating.
-- Return: user_id, watch_date, title, watch_duration_mins,
--         user_avg_mins, is_above_threshold (TRUE/FALSE).
--
-- HINT: Calculate AVG(watch_duration_mins) OVER (PARTITION BY user_id) to
--       get each user's personal average on every row. Then compare each
--       row's duration against that value in a CASE or boolean expression.

-- [Your query here]


-- Q3.5
-- For each genre, show the total watch count per month and the watch count
-- from the previous month. Also calculate the month-over-month change.
-- Return: genre, watch_month, monthly_views, prev_month_views, mom_change.
-- Order by genre, watch_month.
--
-- HINT: First aggregate monthly views per genre with GROUP BY.
--       Then apply LAG(monthly_views, 1) OVER (PARTITION BY genre ORDER BY watch_month).
--       Subtract to get mom_change (will be NULL for each genre's first month).

-- [Your query here]


-- ================================================================
-- PHASE 4: ADVANCED — CTEs, COHORTS & COMPLEX LOGIC
-- Topics: Multi-step CTEs, cohort analysis, funnel analysis,
--         subscription journey logic
-- ================================================================

-- Q4.1
-- Build a subscription journey summary for each user.
-- For users with more than one subscription record, show their plan
-- progression, total number of plan changes, and whether they ever cancelled.
-- Return: user_id, full_name, plan_progression (e.g. 'free → basic → premium'),
--         total_plan_changes, ever_cancelled (TRUE/FALSE).
--
-- HINT: DuckDB supports STRING_AGG(plan_type, ' → ' ORDER BY start_date)
--       to build the progression string.
--       Use COUNT(*) per user for total_plan_changes.
--       Use MAX(status = 'cancelled') to produce the ever_cancelled boolean.

-- [Your query here]


-- Q4.2
-- Cohort retention analysis:
-- Group users by the month they first watched any content (their "cohort month").
-- Then, for each subsequent month, calculate how many users from that cohort
-- returned to watch again.
-- Return: cohort_month, months_since_first_watch (0, 1, 2, ...),
--         cohort_size, retained_users, retention_rate.
-- Round retention_rate to 2 decimal places.
--
-- HINT: Step 1 — Find each user's first watch month:
--                MIN(DATE_TRUNC('month', watch_date)) AS cohort_month
--       Step 2 — Join watch_history back to the cohort table and compute
--                DATEDIFF('month', cohort_month, watch_month) for the offset.
--       Step 3 — Count distinct users per cohort + offset, then divide
--                by cohort_size for the retention rate.
--       This will require at least 2-3 CTEs.

-- [Your query here]


-- Q4.3
-- Identify users who appear to have "churned" — defined here as users
-- whose most recent watch event was more than 90 days before 2023-07-01
-- (the end of our dataset) AND who do not have an active subscription.
-- Return: user_id, full_name, last_watch_date, current_plan_status,
--         days_since_last_watch.
--
-- HINT: Use MAX(watch_date) per user to get last_watch_date.
--       To get each user's most recent subscription, use
--       ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY start_date DESC)
--       and filter to row 1.
--       Then filter where (DATE '2023-07-01' - last_watch_date) > 90
--       and status != 'active'.

-- [Your query here]


-- Q4.4
-- For each content title, calculate a "popularity score" defined as:
--     (total_views * 0.4) + (completion_rate * 100 * 0.4) + (unique_viewers * 0.2)
-- Return: title, genre, total_views, completion_rate, unique_viewers, popularity_score.
-- Order by popularity_score descending. Round to 2 decimal places.
--
-- HINT: Build all three metrics in a single CTE using aggregations
--       (COUNT(*) for total_views, AVG(completed::INTEGER) for completion_rate,
--       COUNT(DISTINCT user_id) for unique_viewers), then apply the formula
--       in the outer SELECT.

-- [Your query here]


-- Q4.5 (CHALLENGE)
-- Find users who watched content in at least 3 consecutive calendar months.
-- Return: user_id, full_name, streak_start_month, streak_end_month,
--         streak_length_months.
-- Only return users with a streak of 3 or more months.
--
-- HINT: This is a gaps-and-islands problem.
--       Step 1 — Get each user's distinct watch months using
--                DATE_TRUNC('month', watch_date).
--       Step 2 — Assign a row number per user ordered by month.
--                Subtract it (as a month offset) from the month itself
--                to create a group key — consecutive months will share
--                the same key.
--                DuckDB tip: DATEDIFF('month', DATE '2000-01-01', watch_month)
--                gives an integer you can subtract ROW_NUMBER from.
--       Step 3 — GROUP BY user_id + group key, count months in the group,
--                then filter where streak_length_months >= 3.

-- [Your query here]


-- ================================================================
-- END OF PROJECT
-- ================================================================
