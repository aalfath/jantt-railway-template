[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/jantt-1?utm_medium=integration&utm_source=button&utm_campaign=jantt)

# Jantt on Railway

Deploys [Jantt](https://github.com/AhmadHassan-BTed/Jantt) **v1.1.0**, an open-source (MIT) interactive Gantt chart and project-planning workspace, as a single Railway service.

## What this template deploys

| Service | What it does | Source |
|---|---|---|
| `Jantt` | Builds the Jantt web app from the upstream `v1.1.0` tag (commit `681afec`) and serves it with nginx on `$PORT`. Health check: `/healthz`. | This repo's `Dockerfile` |

Upstream publishes no container image, so the `Dockerfile` clones the release tag, checks its commit hash, builds it with `node:22.23.5-alpine` and serves it with `nginx:1.30.8-alpine`. Every base image is pinned by version **and** digest.

- **No database and no volume.** Jantt keeps your plans in your own browser (localStorage). The server only serves the app, so a redeploy or restart never touches your data. To move or back up a plan, use **Export** (JSON, CSV, MS Project XML and more) and **Import**.
- **No variables to fill in.** `PORT` is the only variable (default `8080`).
- **AI:** v1.1.0's **AI Prompt** button copies a ready-made prompt you paste into any chatbot (ChatGPT, Claude, Gemini, a local model); you paste the JSON it returns back into Jantt. No API key is stored on the server.
- **Cloud rooms and GitHub sign-in** are wired by upstream to the Jantt author's own Firebase project and only work on the author's site, not on your domain. Remote-URL import falls back to the author's CORS proxy for hosts that block cross-origin requests. Everything else works offline in the browser.
- **Small:** idles at a few MB of RAM, so it runs on Railway's Free plan (0.5 GB).

## Updates

When a new Jantt release comes out, we bump `JANTT_VERSION` and `JANTT_COMMIT` in the `Dockerfile` and add an entry to [`CHANGELOG.md`](CHANGELOG.md). Railway then shows **"update available"** on every project deployed from this template, and you choose when to apply it. Your plans stay in your browser, so updates never touch them.

## Licence

The wrapper files in this repo are MIT. Jantt itself is MIT, © Ahmad Hassan & Jantt Project Contributors.
