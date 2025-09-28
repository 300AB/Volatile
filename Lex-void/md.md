# 🩸 Name Generator & Optimizer — Project Plan

## 🕯️ Core Project Goals:
Build a tool to **generate, analyze, and score usernames** based on:
- Visual compactness (glyph shape + pixel width)
- Readability & word-like qualities
- Character makeup (count, case sensitivity, types)
- Charm factors (subjective, but scaffolded for future refinement)

---

## ⚙️ Modules & Features:

### 1. Word Authenticity Score (`C.larity`)
- **Purpose:** Detect whether the name resembles real words (for readability/charm).
- **Sub-Features:**
  - `1a.` Detect % of the name that matches known words or resembles them.
  - `1b.` Count *how many* recognizable words are present inside the name.
  - `1c.` Minimum word length for detection (avoid trivial short words like “a” or “ok” — customizable threshold).

---

### 2. Visual Weight Typing (`Weight Pos Type`)
- **Purpose:** Assign names into visual categories based on glyph *visual weight* and flow.
- **Categories (Customizable):**
  - `Top-Heavy`
  - `Mid-Heavy`
  - `Bottom-Heavy`
  - `Flow-Type` (Curly, smooth, etc.)
- **Sub-Features:**
  - `2a.` Automatically assign names into categories based on weighted glyph analysis.
  - `2b.` Compare upper vs. lowercase explicitly; case-sensitive analysis allowed.
  - `2c.` Clean, well-defined categories (e.g., “flow” defined by curved glyphs like `s`, `e`, `c`, etc.).

---

### 3. Character Count Analysis
- **Purpose:** Simple sanity check on name length & complexity.
- **Sub-Features:**
  - `3a.` Count total characters.
  - Optionally track capital letters separately (for pattern analysis or aesthetics).

---

### 4. Pixel Density Calculation
- **Purpose:** Measure physical width of the name as rendered text.
- **Details:**
  - Uses font rendering (e.g., via Pillow) for precise pixel width.
  - Needs to consider edge cases where capitalization affects width.

---

### 5. Visual Density Pattern Analysis (via Weight Pos Typing)
- **Purpose:** Assess whether a name’s visual pattern is pleasing or balanced.
- **Sub-Features:**
  - `5a.` Score visual “flow” based on sequence of assigned `Weight Pos Type` categories.
  - Optionally combine with **word authenticity** to detect complex or awkward blends.

---

### 6. Subjective Bias / Charm Scoring (Optional Module)
- **Purpose:** Inject *user-specific bias* into scoring for charm.
- **Sub-Features:**
  - Whitelist of "liked" words, themes, motifs.
  - Names that match or contain these words score higher.
  - Works alongside **Word Authenticity** (cross-scaling possible).

---

## 🔹 Project Notes:
- Everything modular and layered—each scoring system can stand alone.
- Subjective systems (charm, flow aesthetics) can be tuned later via personal data.
- Initially, **focus on building analyzers**—generation can follow once analysis tools work.

---

## 🔸 Potential Libraries:
- **Core Python:** Random, string, basic operations.
- **Pillow:** For pixel width calculation.
- **nltk:** For word detection, phonetic analysis (optional but useful).
