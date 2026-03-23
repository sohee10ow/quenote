# Yoga Cue Notes

## Project Summary
- Korean-only yoga cue notes app
- Flutter mobile app
- Local-first
- No backend
- No login

## Source of Truth
- Always read `docs/design_to_dev_spec_v2.md` before making structural decisions.
- Follow the design spec closely for data model, navigation, UI structure, and sharing behavior.

## Implementation Rules
- Build one screen or one feature at a time.
- Do not implement the whole app at once.
- Use reusable widgets and small files.
- Preserve structured cue sections:
  - preparation cue
  - breath cues by count
  - release cue
- Do not collapse cue data into a single plain text field.
- Keep Korean-only UI labels.
- Match spacing, radius, typography, and theme tokens from the spec.
- Prefer production-oriented Flutter code.
