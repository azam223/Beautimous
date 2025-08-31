# 🌸 Beautimous

**Beautify your WoW client with smarter CVar settings.**
A simple addon made for *World of Warcraft: Wrath of the Lich King 3.3.5a* that makes your game look its best by automatically applying CVar settings every time you log in.

---

## ✨ What It Does

- Enhances **lighting, shadows, and terrain**
- Boosts **particles, spell effects, and water**
- Extends **view distance and environment detail**
- Enables **projected textures, footprints, and other visuals**
- Fails quietly if your client doesn’t support a setting

No need to dig into `Config.wtf`, type endless `/console` commands, or use a half-dozen macros every time you start the game. Beautimous applies the prettiest values your client can handle and skips the rest.

---

## 📥 Installation

1. Download or clone this repo.
2. Place the `Beautimous` folder in:
   ```
   World of Warcraft/Interface/AddOns/
   ```
3. Restart WoW or reload your UI.

Your folder should look like this:

```
World of Warcraft/
└── Interface/
    └── AddOns/
        └── Beautimous/
            ├── Beautimous.lua
            └── Beautimous.toc
```

---

## ⚙️ Usage

Type `/beauty` in chat for help.

- `/beauty apply` → Applies settings quietly
- `/beauty report` → Shows what was changed or skipped
- `/beauty both` → Applies and shows the report

Example output:
```
Beautimous set: farclip=1600, groundEffectDist=600
Beautimous skipped: groundeffectfade
```

---

## 🖼️ Why Use Beautimous?

Beautimous is for players who want Wrath's visuals to shine.
It pushes graphics CVars to their best available values while gracefully handling client quirks like missing or aliased settings.

Think of it as a “make WoW pretty” button that always remembers your favorite look.

---

## 💡 Contributing

Found a missing CVar alias, a prettier setting, or an edge case?
Open a Pull Request or suggest improvements!

---

## 📖 License

MIT License – free to use, share, and improve.
