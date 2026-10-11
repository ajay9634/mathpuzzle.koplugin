# Math Calculation Puzzle Game (`mathpuzzle.koplugin`)

An interactive math calculation practice game plugin built specifically for **KOReader** on Kindle, Android, and e-ink e-readers.

## 🌟 Key Features

* **Continuous Game Loop:** Play uninterrupted rounds with continuous puzzle generation until you choose to exit.
* **All Four Arithmetic Operations:** Dynamically generates problems for:
  * **Addition (`+`)**
  * **Subtraction (`-`)** (Guaranteed non-negative results)
  * **Multiplication (`×`)**
  * **Division (`÷`)** (Guaranteed clean integer quotients)
* **Operator Filtering:** Focus on specific operations (e.g., test only `×` or `÷`) or select `ALL` for mixed challenges.
* **Flexible Difficulty Levels:** 
  * Preset selection for **2-digit** and **3-digit** calculations.
  * Custom digit input allowing anywhere from **1 to 5 digits**.
* **Live Score & Streak Tracking:**
  * Real-time accuracy ratio (`Correct / Total`).
  * Active streak tracker with best session record preservation (`🔥 Current Streak / Best`).
* **Clean Interactive Interface:**
  * On-screen calculator-friendly numeric input.
  * Dedicated GUI buttons for **Submit**, **Next Puzzle**, **Settings**, and **Exit**.
  * Hidden answer verification until submitted.

---

## 📂 Installation

1. Download or copy the `mathpuzzle.koplugin` directory.
2. Place the directory into your KOReader plugins folder:
   * **Kindle / Kobo / PocketBook:** `/koreader/plugins/mathpuzzle.koplugin/`
   * **Android:** `/sdcard/koreader/plugins/mathpuzzle.koplugin/`
3. Restart **KOReader**.
4. Access the game directly from the main menu under **Tools** $\rightarrow$ **Math Calculation Puzzle Game**.

---

## ⚙️ How to Play

1. Open **Math Calculation Puzzle Game** from the Tools menu.
2. Solve the presented equation on screen (e.g., `48 × 6 = ?`).
3. Enter your answer using the on-screen numeric keypad and tap **Submit**.
4. View your results and tap **Next Puzzle** to continue playing or **Exit Game** to leave.
5. Tap **Settings** at any time to modify digit lengths or filter specific math operators.

---

## 🛠️ Requirements

* KOReader v2020.04 or newer.
