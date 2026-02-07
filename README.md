# Private Life OS (Claude Code + LIFE Repo)

Private Life OS is designed to handle the content of your **LIFE repository** interactively using [**Claude Code**](https://claude.ai/code). It provides a structured environment for managing your personal life while maintaining a clear boundary between private context and public output.

This repository is a [**template**](https://github.com/x5gtrn/life-template) for building your Life OS on GitHub:

- **LIFE repo (this repo)** is meant to be **private** and contains your high-context personal operating system:
  - tasks, goals, projects, journals, logs, reviews
- **TIL repo** is meant to be **public** (or at least separate) and contains your low-context, reusable learnings:
  - small notes like “Today I learned …” in Markdown

The key idea is to keep **private life management** and **public learning output** separated, while still allowing the LIFE repo to **import** and **summarize** your TIL daily.

---

## What you can do with this template

### 1) Manage your life with GitHub Issues + Projects

- Capture tasks and ideas quickly (Inbox style)
- Review weekly/monthly using checklists and dashboards
- Keep projects in Markdown for career/health/finance/music

### 2) Keep a public TIL habit without leaking private context

- Write TIL in a separate repo (public)
- Import TIL into LIFE using **git subtree**
- Never mix personal/private notes into public output

### 3) Daily automated updates (04:00 JST)

A GitHub Actions workflow runs **every day at 04:00 JST** and:

- pulls the latest TIL into `vendor/til/` (subtree)
- rebuilds:
  - `docs/til-index.md`
  - `docs/til-daily-digest.md` (what changed today)
  - `docs/til-weekly/YYYY-MM-DD-to-YYYY-MM-DD.md` (Weekly summary from Monday 04:00 JST, rebuilt daily)
- commits and pushes changes back to your LIFE repo **only if there are changes**

### 4) Claude Code Integration

This repository is optimized for use with **Claude Code**. The `.claude/` directory and `CLAUDE.md` provide context and skills (like `agent-memory`, `url-digest`, etc.) that allow Claude to assist you in managing your life, tracking tasks, and generating digests.

---

## Repository structure (high level)

- `.github/ISSUE_TEMPLATE/` — issue templates (Task / Idea / Weekly Priority)
- `.github/workflows/sync-til-daily.yml` — daily TIL sync + docs generation
- `docs/` — handbook, dashboard, privacy rules, reviews, generated TIL summaries
- `journal/` — daily notes (private)
- `projects/` — roadmaps and archived projects (career/health/finance/music)
- `.claude/` — Claude Code configuration and skills (hooks, agent-memory, etc.)
- `CLAUDE.md` — Project context and guide for Claude Code
- `settings.json` — Project settings for skills
- `logs/` — learning/work/health logs (private)
- `scripts/` — sync + index + digest generators
- `vendor/til/` — imported TIL repo content (do not edit manually)

---

## Quick start (recommended setup)

### Step 0) Create your public TIL repository

Create a repo named `til` (public recommended) with default branch `main`.

Minimal structure example:

```text
til/
  README.md
  aws/
  java/
  graphql/
  linux/
```

Push at least one commit so it exists and is fetchable.

---

### Step 1) Use this template to create your LIFE repository

1. Click **Use this template** (or Fork)
2. Name it something like `life`
3. Set visibility to **Private** (strongly recommended)

> You *can* keep it public, but that defeats the purpose of a private life OS.

---

### Step 2) Configure the TIL remote in LIFE

Edit this file:

- `scripts/sync-til.sh`

Replace:

```bash
TIL_REMOTE_URL="https://github.com/<YOUR_NAME>/til.git"
```

with your actual GitHub username or org:

```bash
TIL_REMOTE_URL="https://github.com/YOUR_GITHUB_NAME/til.git"
```

Commit and push:

```bash
git add scripts/sync-til.sh
git commit -m "chore: set TIL remote url"
git push
```

---

### Step 3) Run the first sync locally (recommended)

Clone your LIFE repo and run:

```bash
./scripts/sync-til.sh
./scripts/build-til-index.sh
./scripts/build-til-digests.sh "$(git rev-parse HEAD)"
```

Then commit generated files:

```bash
git add vendor/til docs/til-index.md docs/til-daily-digest.md docs/til-weekly
git commit -m "chore: import TIL subtree and generate docs"
git push
```

This verifies subtree + scripts work before relying on automation.

---

### Step 4) Enable GitHub Actions auto-commit

This template includes a workflow:

- `.github/workflows/sync-til-daily.yml`

It needs permission to push commits.

Go to:

- **Settings → Actions → General → Workflow permissions**
- Select: **Read and write permissions**

No secrets are required for public TIL.

---

### Step 5) Test the workflow manually

Go to:

- **Actions → Sync TIL daily → Run workflow**

If successful, your repo will update:

- `vendor/til/`
- `docs/til-index.md`
- `docs/til-daily-digest.md`
- `docs/til-weekly/YYYY-MM-DD-to-YYYY-MM-DD.md`

---

## Daily workflow (how to actually use it)

### Write TIL (public)

In your `til` repo, add small Markdown notes:

- 1 file = 1 idea
- keep it reusable, general, no private context

Then push.

### Review inside LIFE (private)

In your LIFE repo, use these generated views:

- `docs/til-daily-digest.md` — “What changed today?”
- `docs/til-weekly/` — “What changed this week (starting Monday 04:00 JST)?”

And your ops docs:

- `docs/dashboard.md` — your review hub
- `docs/weekly-review.md` — weekly checklist
- `docs/monthly-review.md` — monthly checklist

---

## GitHub Projects setup (suggested)

This template doesn’t create a Project for you automatically, but here’s a strong default:

Create a GitHub Project (v2) named: **LIFE**

Suggested fields:

- Status: Inbox / Next / Doing / Done / Someday
- Area: career / learning / health / finance / music / life / work
- Priority: High / Mid / Low
- Timebox: 15m / 30m / 60m / 2h / 4h / 1d+
- Due: date
- Energy: Low / Medium / High
- Context: Deep Work / Shallow / Errands / PC / Phone / Outside

Use these views:

- Board: Flow (group by Status)
- Table: Today/Next (filter Priority/Due)
- Roadmap: Horizon (use Due)

---

## Privacy & safety (read this)

**TIL is public. LIFE is private. Keep the boundary clean.**

Never put these into TIL:

- client/company names
- money/contracts
- precise locations/schedules
- health details
- personal relationships/messages

Use LIFE for raw notes; rewrite to TIL as generalized learning.

Also:

- **Do not edit `vendor/til/` manually**. It’s managed by subtree.
- Keep `vendor/til` as “import-only”.

See: `docs/privacy.md`

---

## Customization tips

### Change the daily run time

In `.github/workflows/sync-til-daily.yml`, update the cron.
Current schedule:

- **04:00 JST** = `0 19 * * *` (UTC)

### Add more digest types

- Monthly digests
- “Top topics” summary
- Search index generation

### Add your own Areas

Update Issue templates and Project fields to match your life domains.

---

## Troubleshooting

### Actions can’t push

- Ensure **Workflow permissions** are **Read and write**
- Ensure `permissions: contents: write` exists in the workflow (it does in this template)

### Subtree pull fails

Common causes:

- you edited `vendor/til/` manually
- default branch mismatch (`main` vs `master`)

Fix:

- revert local edits in `vendor/til/`
- update `TIL_BRANCH` in `scripts/sync-til.sh`

### Digest files look empty

- If there were no changes in TIL since last sync, daily digest will say “No changes”
- Weekly digest rebuilds daily and may show none if you didn’t update TIL this week

---

## License

Use whatever license you prefer for your template. (Add one if you plan to publish widely.)

---

## Credits / Inspiration

This template is inspired by the “manage your life with GitHub” approach and the broader TIL culture.

- https://www.youtube.com/watch?v=KHiq6nf0Jio
- https://www.youtube.com/watch?v=wNLE7rQDLN0
- https://zenn.dev/hand_dot/articles/85c9640b7dcc66

