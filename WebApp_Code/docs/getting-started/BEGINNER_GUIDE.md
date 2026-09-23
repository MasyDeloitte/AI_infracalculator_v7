# Beginner Guide

## What the folders mean
- `apps/web`: browser user interface.
- `apps/api`: backend API.
- `docs`: product and developer documentation.
- `scripts`: numbered Windows scripts. Run them in order.

## Safe editing workflow
1. Create a Git branch.
2. Change one feature only.
3. Run `03-check-project.bat`.
4. Open all three pages in the browser.
5. Commit with a clear message.

## Rules
- Never place prices, model facts, benchmarks or sizing constants directly in UI files.
- Never remove `Udev` until a feature passes its checkpoint.
- Never store passwords or tokens in Git. Use `.env`.
- Add new product features under `apps/web/src/features/<feature-name>`.
- Keep page components focused on layout; move reusable logic into feature folders.
