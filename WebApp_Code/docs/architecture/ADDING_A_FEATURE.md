# Adding a Feature

1. Create `apps/web/src/features/<feature>`.
2. Add `components`, `hooks`, `api`, `types`, and `tests` only when needed.
3. Add a small page-level integration.
4. Add tests for user-visible behavior.
5. Add an API router under `apps/api/app/api/v1`.
6. Do not mix calculation logic into React components.
