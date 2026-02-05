# Dashboard (Weekly Review Hub)

Use this as your single entry point during reviews.

## 1) Today
- Open your GitHub Project: **LIFE** (Table view: Today / Next)
- Check `docs/til-daily-digest.md` (what changed since last sync)

## 2) This week (ISO week)
- Open current weekly digest in `docs/til-weekly/`
  - Example: `docs/til-weekly/2026-W06.md`
- Run the checklist: `docs/weekly-review.md`

## 3) Monthly
- `docs/monthly-review.md`
- Update plans:
  - `plans/career/roadmap.md`
  - `plans/health/routines.md`
  - `plans/finance/budget.md`
  - `plans/music/next-release.md`

## 4) Key docs
- Handbook: `docs/handbook.md`
- Privacy: `docs/privacy.md`
- TIL Index: `docs/til-index.md`

## 5) Commands
```bash
# Sync + rebuild docs locally
./scripts/sync-til.sh
./scripts/build-til-index.sh
./scripts/build-til-digests.sh "$(git rev-parse HEAD)"
```

## 6) Quick rules (keep it sustainable)
- Capture fast in Issues (Inbox), organize weekly.
- Keep Doing <= 3 items.
- Publish only generalized learnings to public TIL.
