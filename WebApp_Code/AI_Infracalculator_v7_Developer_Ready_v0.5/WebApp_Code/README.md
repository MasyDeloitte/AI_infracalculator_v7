# AI Infrastructure Sizing Platform

A beginner-friendly and scalable monorepo for the AI infrastructure sizing application.

## First-time setup on Windows
1. Install Node.js 20.19 or later and Python 3.12. Docker is not required.
2. Double-click `scripts\01-setup.bat`.
3. Double-click `scripts\02-run-local.bat`.
4. Open `http://127.0.0.1:5173`. API documentation is at `http://127.0.0.1:8000/docs`.

## Before committing
Run `scripts\03-check-project.bat`.

## Where to edit
- Landing page: `apps/web/src/pages/landing/LandingPage.tsx`
- Executive inputs: `apps/web/src/pages/inputs/ExecutiveInputsPage.tsx`
- BOM and financials: `apps/web/src/pages/bom/BomFinancialsPage.tsx`
- Workload sample data: `apps/web/src/features/workloads/sampleWorkloads.ts`
- Shared layout: `apps/web/src/components/layout/AppShell.tsx`
- Colors and spacing: `apps/web/src/styles/tokens.css`
- API: `apps/api/app`

Read `docs/getting-started/BEGINNER_GUIDE.md` before editing.
