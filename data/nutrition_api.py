"""
TaiYiYuan (太医院) — Nutrition API Client

Looks up nutritional information from USDA FoodData Central and
Open Food Facts. Results are cached in the TaiYiYuan database
with a 90-day expiry.

Uses only stdlib: urllib.request, json, os. No external dependencies.
"""

import json
import os
import urllib.error
import urllib.parse
import urllib.request
from typing import Optional

from .db import TaiYiYuanDB


# USDA FoodData Central nutrient ID → our schema field mapping
# https://fdc.nal.usda.gov/api-guide.html
USDA_NUTRIENT_MAP = {
    1008: "calories",       # Energy (kcal)
    1003: "protein_g",      # Protein
    1005: "carbs_g",        # Carbohydrate, by difference
    1004: "fat_g",          # Total lipid (fat)
    1079: "fiber_g",        # Fiber, total dietary
    1106: "vitamin_a_mcg",  # Vitamin A, RAE
    1165: "vitamin_b1_mg",  # Thiamin
    1166: "vitamin_b2_mg",  # Riboflavin
    1167: "vitamin_b3_mg",  # Niacin
    1170: "vitamin_b5_mg",  # Pantothenic acid
    1175: "vitamin_b6_mg",  # Vitamin B-6
    1176: "vitamin_b7_mcg", # Biotin
    1177: "vitamin_b9_mcg", # Folate, total
    1178: "vitamin_b12_mcg",# Vitamin B-12
    1162: "vitamin_c_mg",   # Vitamin C
    1114: "vitamin_d_mcg",  # Vitamin D (D2 + D3)
    1109: "vitamin_e_mg",   # Vitamin E (alpha-tocopherol)
    1185: "vitamin_k_mcg",  # Vitamin K (phylloquinone)
    1087: "calcium_mg",     # Calcium
    1089: "iron_mg",        # Iron
    1090: "magnesium_mg",   # Magnesium
    1095: "zinc_mg",        # Zinc
    1092: "potassium_mg",   # Potassium
    1093: "sodium_mg",      # Sodium
}

# Common ingredient aliases (Chinese → English, abbreviations, etc.)
INGREDIENT_ALIASES = {
    # Chinese staples
    "鸡蛋": "egg whole raw",
    "鸡胸肉": "chicken breast raw",
    "牛肉": "beef ground raw",
    "猪肉": "pork loin raw",
    "三文鱼": "salmon atlantic raw",
    "虾": "shrimp raw",
    "米饭": "rice white cooked",
    "白米饭": "rice white cooked",
    "糙米": "rice brown cooked",
    "面条": "noodles wheat cooked",
    "馒头": "steamed bread wheat",
    "豆腐": "tofu firm raw",
    "牛奶": "milk whole",
    "酸奶": "yogurt plain whole milk",
    "西兰花": "broccoli raw",
    "菠菜": "spinach raw",
    "番茄": "tomato raw",
    "土豆": "potato raw",
    "红薯": "sweet potato raw",
    "苹果": "apple raw",
    "香蕉": "banana raw",
    "蓝莓": "blueberries raw",
    "牛油果": "avocado raw",
    "杏仁": "almonds",
    "核桃": "walnuts english",
    "橄榄油": "olive oil",
    "花生酱": "peanut butter",
    "燕麦": "oats",
    # Common English shorthand
    "chicken breast": "chicken breast meat raw",
    "salmon": "salmon atlantic raw",
    "brown rice": "rice brown long grain cooked",
    "white rice": "rice white long grain cooked",
    "sweet potato": "sweet potato raw",
    "olive oil": "oil olive",
    "greek yogurt": "yogurt greek plain nonfat",
    "oatmeal": "oats regular cooked",
    "avocado": "avocado raw",
    "egg": "egg whole raw",
    "eggs": "egg whole raw",
    "banana": "banana raw",
    "broccoli": "broccoli raw",
    "spinach": "spinach raw",
}

# Request timeout in seconds
REQUEST_TIMEOUT = 15


class NutritionLookup:
    """Look up nutritional information for ingredients.

    Uses USDA FoodData Central as the primary source, Open Food Facts
    as fallback (for packaged goods). Results are cached in the
    TaiYiYuan database with a 90-day TTL.

    Usage:
        with TaiYiYuanDB() as db:
            lookup = NutritionLookup(db)
            info = lookup.lookup("chicken breast")
            # info = {"calories": 165, "protein_g": 31, ...}

            batch = lookup.batch_lookup(["egg", "spinach", "olive oil"])
            # batch = {"egg": {...}, "spinach": {...}, "olive oil": {...}}
    """

    def __init__(self, db: TaiYiYuanDB, api_key: str = None):
        """Initialize the nutrition lookup client.

        Args:
            db: TaiYiYuanDB instance (must be connected) for caching.
            api_key: USDA FoodData Central API key. If not provided,
                     reads from USDA_API_KEY environment variable.
                     Get a free key at: https://fdc.nal.usda.gov/api-key-signup.html
        """
        self.db = db
        self.api_key = api_key or os.environ.get("USDA_API_KEY")
        if not self.api_key:
            # USDA provides a demo key with low rate limits
            self.api_key = "DEMO_KEY"

    def lookup(self, ingredient: str) -> Optional[dict]:
        """Look up nutrition data for an ingredient.

        Checks cache first, then queries USDA FoodData Central,
        then falls back to Open Food Facts.

        Args:
            ingredient: Ingredient name (English or Chinese).

        Returns:
            Dict of nutrient values keyed by our schema field names
            (e.g., {'calories': 155, 'protein_g': 12.6, ...}),
            or None if not found.
        """
        normalized = self._normalize_ingredient(ingredient)

        # 1. Check cache
        cached = self.db.get_cached_nutrition(normalized)
        if cached:
            return cached["nutrients"]

        # 2. Try USDA FoodData Central
        result = self._search_usda(normalized)
        if result:
            self.db.cache_nutrition(
                normalized_ingredient=normalized,
                fdc_id=result.get("fdc_id"),
                nutrients=result["nutrients"],
                source="usda",
            )
            return result["nutrients"]

        # 3. Try Open Food Facts (better for packaged/branded items)
        result = self._search_openfoodfacts(normalized)
        if result:
            self.db.cache_nutrition(
                normalized_ingredient=normalized,
                fdc_id=None,
                nutrients=result["nutrients"],
                source="openfoodfacts",
            )
            return result["nutrients"]

        return None

    def batch_lookup(self, ingredients: list[str]) -> dict[str, Optional[dict]]:
        """Look up nutrition data for multiple ingredients.

        Args:
            ingredients: List of ingredient names.

        Returns:
            Dict mapping ingredient name → nutrient dict (or None).
        """
        results = {}
        for ing in ingredients:
            results[ing] = self.lookup(ing)
        return results

    def _normalize_ingredient(self, name: str) -> str:
        """Normalize an ingredient name for consistent caching and lookup.

        Applies: lowercase, strip whitespace, resolve aliases.

        Args:
            name: Raw ingredient name.

        Returns:
            Normalized name string.
        """
        cleaned = name.strip().lower()

        # Check aliases (exact match after lowercasing)
        if cleaned in INGREDIENT_ALIASES:
            return INGREDIENT_ALIASES[cleaned]

        # Remove common filler words
        for filler in ["fresh ", "organic ", "raw ", "cooked "]:
            if cleaned.startswith(filler):
                # Keep "raw" and "cooked" info for USDA but strip "fresh"/"organic"
                if filler in ("fresh ", "organic "):
                    cleaned = cleaned[len(filler):]

        return cleaned

    def _search_usda(self, query: str) -> Optional[dict]:
        """Search USDA FoodData Central API.

        Endpoint: https://api.nal.usda.gov/fdc/v1/foods/search

        Prefers "SR Legacy" and "Foundation" data types for whole foods.

        Args:
            query: Normalized ingredient name.

        Returns:
            Dict with 'fdc_id' and 'nutrients' keys, or None.
        """
        params = urllib.parse.urlencode({
            "api_key": self.api_key,
            "query": query,
            "dataType": "SR Legacy,Foundation",
            "pageSize": 5,
        })
        url = f"https://api.nal.usda.gov/fdc/v1/foods/search?{params}"

        try:
            req = urllib.request.Request(url)
            req.add_header("User-Agent", "TaiYiYuan/1.0")
            with urllib.request.urlopen(req, timeout=REQUEST_TIMEOUT) as resp:
                data = json.loads(resp.read().decode("utf-8"))
        except (urllib.error.URLError, urllib.error.HTTPError, json.JSONDecodeError, OSError) as e:
            # Network error or bad response — fail gracefully
            return None

        foods = data.get("foods", [])
        if not foods:
            return None

        # Take the first (highest relevance) result
        food = foods[0]
        fdc_id = food.get("fdcId")
        food_nutrients = food.get("foodNutrients", [])

        nutrients = {}
        for fn in food_nutrients:
            nutrient_id = fn.get("nutrientId")
            value = fn.get("value")
            if nutrient_id in USDA_NUTRIENT_MAP and value is not None:
                field = USDA_NUTRIENT_MAP[nutrient_id]
                nutrients[field] = round(value, 2)

        if not nutrients:
            return None

        return {
            "fdc_id": fdc_id,
            "nutrients": nutrients,
            "description": food.get("description", ""),
        }

    def _search_openfoodfacts(self, query: str) -> Optional[dict]:
        """Search Open Food Facts API.

        Endpoint: https://world.openfoodfacts.org/cgi/search.pl

        Better for packaged/branded foods.

        Args:
            query: Normalized ingredient name.

        Returns:
            Dict with 'nutrients' key, or None.
        """
        params = urllib.parse.urlencode({
            "search_terms": query,
            "search_simple": 1,
            "action": "process",
            "json": 1,
            "page_size": 5,
            "fields": "product_name,nutriments",
        })
        url = f"https://world.openfoodfacts.org/cgi/search.pl?{params}"

        try:
            req = urllib.request.Request(url)
            req.add_header("User-Agent", "TaiYiYuan/1.0 (personal health tracker)")
            with urllib.request.urlopen(req, timeout=REQUEST_TIMEOUT) as resp:
                data = json.loads(resp.read().decode("utf-8"))
        except (urllib.error.URLError, urllib.error.HTTPError, json.JSONDecodeError, OSError):
            return None

        products = data.get("products", [])
        if not products:
            return None

        # Take the first result with nutrient data
        for product in products:
            nm = product.get("nutriments", {})
            if not nm:
                continue

            nutrients = {}

            # Map Open Food Facts fields → our schema
            off_map = {
                "energy-kcal_100g": "calories",
                "proteins_100g": "protein_g",
                "carbohydrates_100g": "carbs_g",
                "fat_100g": "fat_g",
                "fiber_100g": "fiber_g",
                "vitamin-a_100g": "vitamin_a_mcg",
                "vitamin-b1_100g": "vitamin_b1_mg",
                "vitamin-b2_100g": "vitamin_b2_mg",
                "vitamin-pp_100g": "vitamin_b3_mg",        # niacin
                "pantothenic-acid_100g": "vitamin_b5_mg",
                "vitamin-b6_100g": "vitamin_b6_mg",
                "biotin_100g": "vitamin_b7_mcg",
                "vitamin-b9_100g": "vitamin_b9_mcg",
                "vitamin-b12_100g": "vitamin_b12_mcg",
                "vitamin-c_100g": "vitamin_c_mg",
                "vitamin-d_100g": "vitamin_d_mcg",
                "vitamin-e_100g": "vitamin_e_mg",
                "vitamin-k_100g": "vitamin_k_mcg",
                "calcium_100g": "calcium_mg",
                "iron_100g": "iron_mg",
                "magnesium_100g": "magnesium_mg",
                "zinc_100g": "zinc_mg",
                "potassium_100g": "potassium_mg",
                "sodium_100g": "sodium_mg",
            }

            for off_key, our_key in off_map.items():
                val = nm.get(off_key)
                if val is not None:
                    try:
                        nutrients[our_key] = round(float(val), 2)
                    except (ValueError, TypeError):
                        continue

            # Need at least macros to be useful
            if "calories" in nutrients or "protein_g" in nutrients:
                return {"nutrients": nutrients}

        return None
