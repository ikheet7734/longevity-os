-- =============================================================================
-- TaiYiYuan (太医院) — Personal Longevity Tracking System
-- SQLite Schema v1
-- =============================================================================
--
-- Timestamps: All stored as UTC ISO 8601 with timezone offset
--             e.g., '2026-03-12T14:30:00+00:00'
--
-- File permissions: Database file should be chmod 0600 (owner read/write only)
--                   Contains sensitive health data.
--
-- Naming conventions:
--   - Tables: snake_case, plural for collections
--   - Columns: snake_case
--   - Foreign keys: <singular_table>_id
--   - Timestamps: created_at/updated_at for audit, timestamp for event time
-- =============================================================================

-- ---------------------------------------------------------------------------
-- Migration tracking
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS schema_version (
    version     INTEGER PRIMARY KEY,
    applied_at  TEXT NOT NULL  -- UTC ISO 8601
);

-- ---------------------------------------------------------------------------
-- DIET MODULE
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS diet_entries (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp         TEXT NOT NULL,                        -- when the meal occurred
    meal_type         TEXT NOT NULL CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack')),
    description       TEXT,                                 -- free-text meal description
    total_calories    REAL,
    total_protein_g   REAL,
    total_carbs_g     REAL,
    total_fat_g       REAL,
    total_fiber_g     REAL,
    photo_path        TEXT,                                 -- relative path to meal photo
    confidence_score  REAL CHECK (confidence_score >= 0 AND confidence_score <= 1),
    notes             TEXT,
    created_at        TEXT NOT NULL,
    updated_at        TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS diet_ingredients (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    entry_id          INTEGER NOT NULL REFERENCES diet_entries(id) ON DELETE CASCADE,
    ingredient_name   TEXT NOT NULL,
    normalized_name   TEXT,                                 -- lowercase, canonical form
    amount_g          REAL,
    calories          REAL,
    protein_g         REAL,
    carbs_g           REAL,
    fat_g             REAL,
    fiber_g           REAL,
    -- Vitamins
    vitamin_a_mcg     REAL,
    vitamin_b1_mg     REAL,                                 -- thiamine
    vitamin_b2_mg     REAL,                                 -- riboflavin
    vitamin_b3_mg     REAL,                                 -- niacin
    vitamin_b5_mg     REAL,                                 -- pantothenic acid
    vitamin_b6_mg     REAL,
    vitamin_b7_mcg    REAL,                                 -- biotin
    vitamin_b9_mcg    REAL,                                 -- folate
    vitamin_b12_mcg   REAL,
    vitamin_c_mg      REAL,
    vitamin_d_mcg     REAL,
    vitamin_e_mg      REAL,
    vitamin_k_mcg     REAL,
    -- Minerals
    calcium_mg        REAL,
    iron_mg           REAL,
    magnesium_mg      REAL,
    zinc_mg           REAL,
    potassium_mg      REAL,
    sodium_mg         REAL,
    created_at        TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS recipe_library (
    id                    INTEGER PRIMARY KEY AUTOINCREMENT,
    name                  TEXT NOT NULL UNIQUE,
    description           TEXT,
    ingredients_json      TEXT,                              -- JSON array of ingredients
    total_nutrition_json  TEXT,                              -- JSON object of totals
    times_logged          INTEGER DEFAULT 0,
    last_used             TEXT,
    created_at            TEXT NOT NULL,
    updated_at            TEXT NOT NULL
);

-- ---------------------------------------------------------------------------
-- EXERCISE MODULE
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS exercise_entries (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp         TEXT NOT NULL,
    activity_type     TEXT NOT NULL,                        -- e.g., 'running', 'weightlifting', 'swimming'
    duration_minutes  REAL,
    distance_km       REAL,
    avg_hr            REAL,                                 -- average heart rate
    rpe               INTEGER CHECK (rpe >= 1 AND rpe <= 10),  -- rate of perceived exertion
    notes             TEXT,
    created_at        TEXT NOT NULL,
    updated_at        TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS exercise_details (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    entry_id          INTEGER NOT NULL REFERENCES exercise_entries(id) ON DELETE CASCADE,
    exercise_name     TEXT NOT NULL,                        -- e.g., 'bench press', 'squat'
    sets              INTEGER,
    reps              INTEGER,
    weight_kg         REAL,
    duration_seconds  REAL,                                 -- for timed exercises
    notes             TEXT
);

-- ---------------------------------------------------------------------------
-- BODY METRICS MODULE
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS body_metrics (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp       TEXT NOT NULL,
    metric_type     TEXT NOT NULL,                          -- e.g., 'weight', 'body_fat', 'blood_pressure_sys'
    value           REAL NOT NULL,
    unit            TEXT NOT NULL,                          -- e.g., 'kg', '%', 'mmHg'
    context         TEXT,                                   -- e.g., 'morning fasted', 'post-workout'
    device_method   TEXT,                                   -- e.g., 'Withings scale', 'manual'
    notes           TEXT,
    created_at      TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS custom_metric_definitions (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    name            TEXT NOT NULL UNIQUE,
    unit            TEXT NOT NULL,
    metric_type     TEXT NOT NULL CHECK (metric_type IN ('continuous', 'categorical', 'ordinal')),
    valid_min       REAL,
    valid_max       REAL,
    description     TEXT,
    created_at      TEXT NOT NULL
);

-- ---------------------------------------------------------------------------
-- BIOMARKERS MODULE
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS biomarkers (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp       TEXT NOT NULL,                          -- date of blood draw / test
    panel_name      TEXT,                                   -- e.g., 'CMP', 'CBC', 'lipid panel'
    marker_name     TEXT NOT NULL,                          -- e.g., 'HbA1c', 'LDL', 'CRP'
    value           REAL NOT NULL,
    unit            TEXT NOT NULL,
    reference_low   REAL,
    reference_high  REAL,
    optimal_low     REAL,                                   -- tighter longevity-optimal range
    optimal_high    REAL,
    notes           TEXT,
    lab_source      TEXT,                                   -- e.g., 'Quest Diagnostics', 'Inside Tracker'
    created_at      TEXT NOT NULL
);

-- ---------------------------------------------------------------------------
-- SUPPLEMENTS MODULE
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS supplements (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    compound_name   TEXT NOT NULL,
    dosage          REAL NOT NULL,
    dosage_unit     TEXT NOT NULL,                          -- e.g., 'mg', 'IU', 'mcg'
    frequency       TEXT NOT NULL,                          -- e.g., 'daily', 'twice daily', '3x/week'
    timing          TEXT,                                   -- e.g., 'morning with food', 'before bed'
    start_date      TEXT NOT NULL,
    end_date        TEXT,                                   -- NULL if currently active
    reason          TEXT,
    brand           TEXT,
    cost_per_unit   REAL,
    notes           TEXT,
    created_at      TEXT NOT NULL,
    updated_at      TEXT NOT NULL
);

-- ---------------------------------------------------------------------------
-- N-OF-1 TRIALS MODULE
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS trials (
    id                      INTEGER PRIMARY KEY AUTOINCREMENT,
    name                    TEXT NOT NULL,
    hypothesis              TEXT NOT NULL,
    intervention            TEXT NOT NULL,
    primary_outcome_metric  TEXT NOT NULL,
    secondary_outcomes_json TEXT,                            -- JSON array of metric names
    design                  TEXT NOT NULL CHECK (design IN ('ABA', 'crossover')),
    phase_duration_days     INTEGER NOT NULL,
    washout_duration_days   INTEGER NOT NULL DEFAULT 0,
    min_observations_per_phase INTEGER NOT NULL DEFAULT 1,
    status                  TEXT NOT NULL DEFAULT 'proposed'
                            CHECK (status IN ('proposed', 'approved', 'active', 'completed', 'abandoned')),
    literature_evidence_json TEXT,                           -- JSON: supporting papers, expected effect sizes
    start_date              TEXT,
    end_date                TEXT,
    created_at              TEXT NOT NULL,
    updated_at              TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS trial_observations (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    trial_id          INTEGER NOT NULL REFERENCES trials(id) ON DELETE CASCADE,
    date              TEXT NOT NULL,
    phase             TEXT NOT NULL CHECK (phase IN ('baseline', 'intervention', 'washout', 'control')),
    metric_name       TEXT NOT NULL,
    value             REAL NOT NULL,
    compliance_score  REAL CHECK (compliance_score >= 0 AND compliance_score <= 1),
    notes             TEXT,
    created_at        TEXT NOT NULL
);

-- ---------------------------------------------------------------------------
-- INSIGHTS & MODEL MODULE
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS insights (
    id                      INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp               TEXT NOT NULL,
    insight_type            TEXT NOT NULL CHECK (insight_type IN ('correlation', 'trend', 'anomaly', 'pattern')),
    source_modules_json     TEXT,                            -- JSON array: ['diet', 'exercise', 'biomarkers']
    description             TEXT NOT NULL,
    statistical_detail_json TEXT,                            -- JSON: full statistical output
    effect_size             REAL,
    p_value                 REAL,
    confidence_level        TEXT DEFAULT 'medium'
                            CHECK (confidence_level IN ('low', 'medium', 'high')),
    evidence_level          INTEGER DEFAULT 1,               -- 1-5 scale
    actionable              INTEGER DEFAULT 0,               -- boolean
    trial_candidate         INTEGER DEFAULT 0,               -- boolean: suggest as n-of-1 trial?
    created_at              TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS model_runs (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp           TEXT NOT NULL,
    run_type            TEXT NOT NULL CHECK (run_type IN ('passive', 'batch', 'deep')),
    modules_analyzed_json TEXT,                              -- JSON array of module names
    duration_seconds    REAL,
    insights_generated  INTEGER DEFAULT 0,
    notes               TEXT
);

CREATE TABLE IF NOT EXISTS model_cache (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    metric_name     TEXT NOT NULL,
    window_type     TEXT NOT NULL CHECK (window_type IN ('7d', '30d', '90d')),
    computed_at     TEXT NOT NULL,
    mean            REAL,
    std             REAL,
    min             REAL,
    max             REAL,
    n               INTEGER,
    trend_slope     REAL,
    extra_json      TEXT,                                    -- JSON: additional computed stats
    UNIQUE(metric_name, window_type)
);

-- ---------------------------------------------------------------------------
-- NUTRITION CACHE
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS nutrition_cache (
    id                    INTEGER PRIMARY KEY AUTOINCREMENT,
    normalized_ingredient TEXT NOT NULL UNIQUE,
    fdc_id                INTEGER,                           -- USDA FoodData Central ID
    nutrients_json        TEXT NOT NULL,                      -- JSON: full nutrient profile
    source                TEXT NOT NULL CHECK (source IN ('usda', 'openfoodfacts', 'estimate')),
    fetched_at            TEXT NOT NULL,
    expires_at            TEXT NOT NULL                       -- fetched_at + 90 days
);

-- ---------------------------------------------------------------------------
-- INDEXES
-- ---------------------------------------------------------------------------

-- Diet
CREATE INDEX IF NOT EXISTS idx_diet_entries_timestamp ON diet_entries(timestamp);
CREATE INDEX IF NOT EXISTS idx_diet_entries_meal_type ON diet_entries(meal_type);
CREATE INDEX IF NOT EXISTS idx_diet_ingredients_entry_id ON diet_ingredients(entry_id);
CREATE INDEX IF NOT EXISTS idx_diet_ingredients_normalized ON diet_ingredients(normalized_name);

-- Exercise
CREATE INDEX IF NOT EXISTS idx_exercise_entries_timestamp ON exercise_entries(timestamp);
CREATE INDEX IF NOT EXISTS idx_exercise_entries_activity ON exercise_entries(activity_type);
CREATE INDEX IF NOT EXISTS idx_exercise_details_entry_id ON exercise_details(entry_id);

-- Body metrics
CREATE INDEX IF NOT EXISTS idx_body_metrics_timestamp ON body_metrics(timestamp);
CREATE INDEX IF NOT EXISTS idx_body_metrics_type ON body_metrics(metric_type);
CREATE INDEX IF NOT EXISTS idx_body_metrics_type_timestamp ON body_metrics(metric_type, timestamp);

-- Biomarkers
CREATE INDEX IF NOT EXISTS idx_biomarkers_timestamp ON biomarkers(timestamp);
CREATE INDEX IF NOT EXISTS idx_biomarkers_marker ON biomarkers(marker_name);
CREATE INDEX IF NOT EXISTS idx_biomarkers_panel ON biomarkers(panel_name);

-- Supplements
CREATE INDEX IF NOT EXISTS idx_supplements_active ON supplements(end_date);
CREATE INDEX IF NOT EXISTS idx_supplements_compound ON supplements(compound_name);

-- Trials
CREATE INDEX IF NOT EXISTS idx_trials_status ON trials(status);
CREATE INDEX IF NOT EXISTS idx_trial_observations_trial_id ON trial_observations(trial_id);
CREATE INDEX IF NOT EXISTS idx_trial_observations_date ON trial_observations(date);
CREATE INDEX IF NOT EXISTS idx_trial_observations_phase ON trial_observations(phase);

-- Insights
CREATE INDEX IF NOT EXISTS idx_insights_timestamp ON insights(timestamp);
CREATE INDEX IF NOT EXISTS idx_insights_type ON insights(insight_type);
CREATE INDEX IF NOT EXISTS idx_insights_actionable ON insights(actionable);

-- Model
CREATE INDEX IF NOT EXISTS idx_model_cache_metric_window ON model_cache(metric_name, window_type);
CREATE INDEX IF NOT EXISTS idx_model_runs_timestamp ON model_runs(timestamp);

-- Nutrition cache
CREATE INDEX IF NOT EXISTS idx_nutrition_cache_ingredient ON nutrition_cache(normalized_ingredient);
CREATE INDEX IF NOT EXISTS idx_nutrition_cache_expires ON nutrition_cache(expires_at);
