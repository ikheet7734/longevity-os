-- Migration 001: Initial schema
-- Applied by: scripts/migrate.py
--
-- TaiYiYuan (太医院) — Personal Longevity Tracking System
-- Creates all tables, indexes, and seeds schema_version.

BEGIN TRANSACTION;

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
    timestamp         TEXT NOT NULL,
    meal_type         TEXT NOT NULL CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack')),
    description       TEXT,
    total_calories    REAL,
    total_protein_g   REAL,
    total_carbs_g     REAL,
    total_fat_g       REAL,
    total_fiber_g     REAL,
    photo_path        TEXT,
    confidence_score  REAL CHECK (confidence_score >= 0 AND confidence_score <= 1),
    notes             TEXT,
    created_at        TEXT NOT NULL,
    updated_at        TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS diet_ingredients (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    entry_id          INTEGER NOT NULL REFERENCES diet_entries(id) ON DELETE CASCADE,
    ingredient_name   TEXT NOT NULL,
    normalized_name   TEXT,
    amount_g          REAL,
    calories          REAL,
    protein_g         REAL,
    carbs_g           REAL,
    fat_g             REAL,
    fiber_g           REAL,
    vitamin_a_mcg     REAL,
    vitamin_b1_mg     REAL,
    vitamin_b2_mg     REAL,
    vitamin_b3_mg     REAL,
    vitamin_b5_mg     REAL,
    vitamin_b6_mg     REAL,
    vitamin_b7_mcg    REAL,
    vitamin_b9_mcg    REAL,
    vitamin_b12_mcg   REAL,
    vitamin_c_mg      REAL,
    vitamin_d_mcg     REAL,
    vitamin_e_mg      REAL,
    vitamin_k_mcg     REAL,
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
    ingredients_json      TEXT,
    total_nutrition_json  TEXT,
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
    activity_type     TEXT NOT NULL,
    duration_minutes  REAL,
    distance_km       REAL,
    avg_hr            REAL,
    rpe               INTEGER CHECK (rpe >= 1 AND rpe <= 10),
    notes             TEXT,
    created_at        TEXT NOT NULL,
    updated_at        TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS exercise_details (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    entry_id          INTEGER NOT NULL REFERENCES exercise_entries(id) ON DELETE CASCADE,
    exercise_name     TEXT NOT NULL,
    sets              INTEGER,
    reps              INTEGER,
    weight_kg         REAL,
    duration_seconds  REAL,
    notes             TEXT
);

-- ---------------------------------------------------------------------------
-- BODY METRICS MODULE
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS body_metrics (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp       TEXT NOT NULL,
    metric_type     TEXT NOT NULL,
    value           REAL NOT NULL,
    unit            TEXT NOT NULL,
    context         TEXT,
    device_method   TEXT,
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
    timestamp       TEXT NOT NULL,
    panel_name      TEXT,
    marker_name     TEXT NOT NULL,
    value           REAL NOT NULL,
    unit            TEXT NOT NULL,
    reference_low   REAL,
    reference_high  REAL,
    optimal_low     REAL,
    optimal_high    REAL,
    notes           TEXT,
    lab_source      TEXT,
    created_at      TEXT NOT NULL
);

-- ---------------------------------------------------------------------------
-- SUPPLEMENTS MODULE
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS supplements (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    compound_name   TEXT NOT NULL,
    dosage          REAL NOT NULL,
    dosage_unit     TEXT NOT NULL,
    frequency       TEXT NOT NULL,
    timing          TEXT,
    start_date      TEXT NOT NULL,
    end_date        TEXT,
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
    secondary_outcomes_json TEXT,
    design                  TEXT NOT NULL CHECK (design IN ('ABA', 'crossover')),
    phase_duration_days     INTEGER NOT NULL,
    washout_duration_days   INTEGER NOT NULL DEFAULT 0,
    min_observations_per_phase INTEGER NOT NULL DEFAULT 1,
    status                  TEXT NOT NULL DEFAULT 'proposed'
                            CHECK (status IN ('proposed', 'approved', 'active', 'completed', 'abandoned')),
    literature_evidence_json TEXT,
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
    source_modules_json     TEXT,
    description             TEXT NOT NULL,
    statistical_detail_json TEXT,
    effect_size             REAL,
    p_value                 REAL,
    confidence_level        TEXT DEFAULT 'medium'
                            CHECK (confidence_level IN ('low', 'medium', 'high')),
    evidence_level          INTEGER DEFAULT 1,
    actionable              INTEGER DEFAULT 0,
    trial_candidate         INTEGER DEFAULT 0,
    created_at              TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS model_runs (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp           TEXT NOT NULL,
    run_type            TEXT NOT NULL CHECK (run_type IN ('passive', 'batch', 'deep')),
    modules_analyzed_json TEXT,
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
    extra_json      TEXT,
    UNIQUE(metric_name, window_type)
);

-- ---------------------------------------------------------------------------
-- NUTRITION CACHE
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS nutrition_cache (
    id                    INTEGER PRIMARY KEY AUTOINCREMENT,
    normalized_ingredient TEXT NOT NULL UNIQUE,
    fdc_id                INTEGER,
    nutrients_json        TEXT NOT NULL,
    source                TEXT NOT NULL CHECK (source IN ('usda', 'openfoodfacts', 'estimate')),
    fetched_at            TEXT NOT NULL,
    expires_at            TEXT NOT NULL
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

-- ---------------------------------------------------------------------------
-- Seed schema version
-- ---------------------------------------------------------------------------
INSERT INTO schema_version (version, applied_at) VALUES (1, datetime('now'));

COMMIT;
