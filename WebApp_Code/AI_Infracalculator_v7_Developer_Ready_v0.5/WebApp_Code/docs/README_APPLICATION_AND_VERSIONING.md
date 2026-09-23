# AI Infrastructure Sizing Platform

**Current approved application baseline:** `v0.3`  
**Next planned version:** `v0.4`  
**Operating system covered by this guide:** Windows 10 or Windows 11  
**Docker requirement:** Docker is not required

---

## 1. Purpose

This README explains:

- How application versions are controlled.
- How to prepare a Windows computer.
- How to copy the application into the correct local folder.
- How to install the required dependencies.
- How to run the frontend and backend.
- How to open and navigate the application.
- How to validate changes before pushing to Git.
- Where a beginner can safely edit the application.
- How to stop, restart, clean, and troubleshoot the application.
- How to release future versions without skipping the approved sequence.

---

## 2. Current Approved Baseline

The current developer-ready application baseline is:

```text
v0.3
```

The current application must be treated as `v0.3` even if an older internal ZIP, folder, or package file contains a temporary version number.

The next approved release must be:

```text
v0.4
```

Future releases must increase sequentially:

```text
v0.3  Current approved baseline
v0.4  Next release
v0.5  Following release
v0.6  Next sequential release
v0.7  Next sequential release
v0.8  Next sequential release
v0.9  Final planned pre-v1.0 release, if required
v1.0  First formally approved production release
```

A version must not be skipped unless the Product Owner explicitly approves and records the reason.

---

## 3. Application Technology

The current development foundation uses:

- React and TypeScript for the web application.
- Vite for local frontend development and production builds.
- Python and FastAPI for the backend API.
- Pytest for backend tests.
- Vitest and Testing Library for frontend tests.
- npm workspaces for managing the frontend package from the repository root.
- Git and GitHub for source control.
- Windows batch scripts for beginner-friendly setup and execution.

The future production design may add PostgreSQL, background workers, object storage, governed catalogs, calculation services, authentication, authorization, audit processing, and observability. Those additions must follow controlled release checkpoints.

---

## 4. Required Local Folder

Store the application in this folder:

```text
C:\Users\masy\Downloads\Projects\Final_GPUSizing_Tool_NonAI\Version7_BuldUCs\Final_App_using_version7Baseline\WebApp_Code
```

The expected structure is:

```text
WebApp_Code
├── apps
│   ├── web
│   └── api
├── docs
├── scripts
├── .github
├── .editorconfig
├── .env.example
├── .gitignore
├── package.json
└── README.md
```

Do not accidentally create this duplicated structure:

```text
WebApp_Code\WebApp_Code
```

---

## 5. Software Requirements

The Windows computer must have:

### Required

- Node.js `20.19` or later.
- npm, installed with Node.js.
- Python `3.12`.
- Git for Windows.
- A modern browser such as Microsoft Edge or Google Chrome.

### Recommended

- Visual Studio Code.
- GitHub Desktop, if command-line Git is uncomfortable.

### Not required

- Docker Desktop.
- Administrator permission after the required software is already installed.

---

## 6. Check Installed Software

Open **Command Prompt** or **PowerShell** and run:

```bat
node --version
npm --version
python --version
git --version
```

Expected results should resemble:

```text
v20.19.0 or later
10.x or later
Python 3.12.x
git version 2.x
```

If a command is not recognized, the corresponding software is missing or is not available in the Windows `PATH`.

---

## 7. Copy or Extract the Application

1. Download the approved application ZIP.
2. Right-click the ZIP and select **Extract All**.
3. Open the extracted folder.
4. Copy the contents inside the extracted `WebApp_Code` folder.
5. Paste the contents into:

```text
C:\Users\masy\Downloads\Projects\Final_GPUSizing_Tool_NonAI\Version7_BuldUCs\Final_App_using_version7Baseline\WebApp_Code
```

6. Verify that this file exists:

```text
WebApp_Code\README.md
```

7. Verify that these scripts exist:

```text
WebApp_Code\scripts\01-setup.bat
WebApp_Code\scripts\02-run-local.bat
WebApp_Code\scripts\03-check-project.bat
WebApp_Code\scripts\04-clean.bat
```

---

## 8. First-Time Application Setup

The setup is required after the application is copied for the first time, or after dependency definitions change.

### Recommended method

Double-click:

```text
WebApp_Code\scripts\01-setup.bat
```

The setup script will:

1. Check that Node.js is available.
2. Check that Python is available.
3. Install frontend dependencies using npm.
4. Create the backend Python virtual environment at:

```text
WebApp_Code\apps\api\.venv
```

5. Upgrade pip inside the virtual environment.
6. Install backend dependencies from:

```text
WebApp_Code\apps\api\requirements.txt
```

7. Create `.env` from `.env.example` if `.env` does not already exist.
8. Display a completion message.

### Command-line alternative

Open Command Prompt and run:

```bat
cd /d "C:\Users\masy\Downloads\Projects\Final_GPUSizing_Tool_NonAI\Version7_BuldUCs\Final_App_using_version7Baseline\WebApp_Code"
scripts\01-setup.bat
```

### Successful setup message

The script should end with a message similar to:

```text
[OK] Setup complete. Run scripts\02-run-local.bat
```

---

## 9. Run the Application

After setup completes, double-click:

```text
WebApp_Code\scripts\02-run-local.bat
```

The run script starts two command windows:

1. The FastAPI backend API.
2. The React frontend development server.

The default browser should open automatically.

### Application URLs

Frontend application:

```text
http://127.0.0.1:5173
```

Backend API documentation:

```text
http://127.0.0.1:8000/docs
```

Backend health endpoint:

```text
http://127.0.0.1:8000/api/v1/health
```

Expected health response:

```json
{
  "status": "ok"
}
```

### Command-line alternative

```bat
cd /d "C:\Users\masy\Downloads\Projects\Final_GPUSizing_Tool_NonAI\Version7_BuldUCs\Final_App_using_version7Baseline\WebApp_Code"
scripts\02-run-local.bat
```

Do not close the frontend or backend command windows while using the application.

---

## 10. Navigate Between the Three Ready Pages

### Landing Page to Executive Inputs

On the Landing Page, select:

```text
Start sizing
```

or:

```text
Open workspace
```

### Executive Inputs to BOM and Financials

On the Executive Inputs Page, select:

```text
Validate & Continue
```

### Sidebar navigation

Inside the workspace:

- Select **Inputs** to open the Executive Inputs Page.
- Select **BOM & Financials** to open the Final BOM and Financials Page.
- Select **Landing page** to return to the Landing Page.

### Under-development items

Other unfinished features are marked:

```text
Udev
```

`Udev` means **Under Development**. Selecting an unfinished feature displays an under-development message and does not execute incomplete functionality.

---

## 11. Stop the Application

To stop the application:

1. Open the frontend command window.
2. Press:

```text
Ctrl + C
```

3. Confirm termination if Windows asks.
4. Open the backend command window.
5. Press:

```text
Ctrl + C
```

6. Close both command windows.

Closing both windows also stops the local application.

---

## 12. Restart the Application

A full setup is not normally required for every restart.

Run:

```text
WebApp_Code\scripts\02-run-local.bat
```

Run `01-setup.bat` again only when:

- The project is being prepared on a new computer.
- `package.json` changes.
- `requirements.txt` changes.
- `node_modules` is deleted.
- `.venv` is deleted.
- Dependency installation becomes corrupted.

---

## 13. Validate the Project

Before committing or pushing changes, run:

```text
WebApp_Code\scripts\03-check-project.bat
```

The validation script runs available checks for:

- TypeScript type validation.
- Frontend linting.
- Frontend automated tests.
- Backend automated tests.

Expected successful result:

```text
[PASS] All available checks passed.
```

A failed check must be corrected before the release is promoted.

---

## 14. Clean Generated Files

To remove generated dependencies, build output, and cache files, run:

```text
WebApp_Code\scripts\04-clean.bat
```

The clean script may remove:

- `node_modules`
- Frontend build output
- Python `__pycache__` folders

The clean script must not delete source code.

After cleaning, run:

```text
WebApp_Code\scripts\01-setup.bat
```

before starting the application again.

---

## 15. Where Beginners Can Edit

### Landing Page

```text
apps\web\src\pages\landing\LandingPage.tsx
```

### Executive Inputs Page

```text
apps\web\src\pages\inputs\ExecutiveInputsPage.tsx
```

### BOM and Financials Page

```text
apps\web\src\pages\bom\BomFinancialsPage.tsx
```

### Sample workload data

```text
apps\web\src\features\workloads\sampleWorkloads.ts
```

### Workload field definition

```text
apps\web\src\features\workloads\types.ts
```

### Shared sidebar and top header

```text
apps\web\src\components\layout\AppShell.tsx
```

### Product name and logo block

```text
apps\web\src\components\layout\Brand.tsx
```

### Colors and spacing

```text
apps\web\src\styles\tokens.css
```

### Backend API entry point

```text
apps\api\app\main.py
```

### Backend health endpoint

```text
apps\api\app\api\v1\health.py
```

---

## 16. Safe Editing Workflow

Use this workflow for every change:

1. Pull the latest Git changes.
2. Create a feature branch.
3. Change one feature or requirement at a time.
4. Start the application.
5. Open all three ready pages.
6. Test positive, negative, and boundary behavior.
7. Run `03-check-project.bat`.
8. Review all changed files.
9. Update release notes and the change log.
10. Commit with a descriptive message.
11. Push the feature branch.
12. Merge only after checkpoint review.

Example branch:

```bat
git checkout -b feature/v0.4-project-persistence
```

Example commit:

```bat
git add .
git commit -m "feat: add project persistence for v0.4"
git push -u origin feature/v0.4-project-persistence
```

---

## 17. Development Guardrails

Developers must not:

- Hardcode model recommendations in React pages.
- Hardcode benchmark figures in UI components.
- Invent GPU compatibility.
- Invent server configurations.
- Treat missing prices as zero.
- Add unapproved formulas or multipliers.
- Mix calculation logic with presentation components.
- store passwords, tokens, certificates, or API keys in Git.
- Remove an `Udev` label before the feature passes its checkpoint.
- Skip an application version.

Use `.env` for local environment settings and secrets.

---

## 18. Troubleshooting

### Node.js is not recognized

Run:

```bat
node --version
```

If Windows cannot find Node.js:

- Confirm Node.js is installed.
- Close and reopen Command Prompt after installation.
- Restart Windows if the `PATH` has not refreshed.

### Python is not recognized

Run:

```bat
python --version
```

If the command fails:

- Confirm Python 3.12 is installed.
- Confirm **Add Python to PATH** was enabled during installation.
- Try the Windows Python launcher:

```bat
py --version
```

### Port 5173 is already in use

Close any older frontend command window and run the application again.

To locate the process:

```bat
netstat -ano | findstr :5173
```

Then stop the process only if the process is confirmed to be the old local frontend:

```bat
taskkill /PID PROCESS_ID /F
```

### Port 8000 is already in use

```bat
netstat -ano | findstr :8000
```

Close the older backend process or stop the confirmed process ID.

### Frontend dependencies fail

From `WebApp_Code`, run:

```bat
scripts\04-clean.bat
scripts\01-setup.bat
```

### Backend virtual environment is damaged

Delete only this generated folder:

```text
WebApp_Code\apps\api\.venv
```

Then run:

```bat
scripts\01-setup.bat
```

### Browser does not open automatically

Open manually:

```text
http://127.0.0.1:5173
```

### API documentation does not open

Confirm the backend command window is still running, then open:

```text
http://127.0.0.1:8000/docs
```

---

## 19. Repository Versioning Rules

The pre-production application uses:

```text
v0.MINOR
```

The major number remains `0` until all production-readiness gates pass.

The minor number increases by one for every controlled release.

The application moves to `v1.0` only after production security, calculation, catalog, testing, BOM, financial, deployment, recovery, and operational acceptance criteria pass.

---

## 20. Mandatory Version Locations

Every release must use the same version in:

1. ZIP filename.
2. Root `package.json`.
3. Frontend `package.json`.
4. Backend API metadata.
5. Application header or About view.
6. README files.
7. Release notes.
8. Change log.
9. Git tag.
10. GitHub release title.
11. API documentation.
12. Test reports.
13. Updated architecture and implementation documents.

Conflicting version numbers are not allowed.

---

## 21. Standard Release Naming

### ZIP package

```text
AI_Infracalculator_v7_v0.4.zip
```

### Git tag

```text
v0.4
```

### GitHub release title

```text
AI Infrastructure Sizing Platform v0.4
```

### Release notes

```text
RELEASE_NOTES_v0.4.md
```

---

## 22. Release Statuses

Every release must have one status:

- `DRAFT`: development is in progress.
- `VALIDATION`: testing is in progress.
- `APPROVED BASELINE`: the official controlled reference.
- `SUPERSEDED`: replaced by a newer approved baseline.
- `BLOCKED`: critical issues prevent promotion.

---

## 23. Checkpoint Results

Every release must finish with:

- `PASS`
- `PASS WITH OPEN ACTIONS`
- `BLOCKED`

A `BLOCKED` release cannot become the approved baseline.

---

## 24. Udev Policy

`Udev` means **Under Development**.

The label remains until the feature:

- Meets approved requirements.
- Has working frontend and backend behavior where applicable.
- Passes validation and error-handling tests.
- Includes required security and accessibility controls.
- Has appropriate documentation.
- Passes its implementation checkpoint.

Removing an `Udev` label is a release change and must be recorded.

---

## 25. Release Checklist

Before creating the next release, verify:

```text
[ ] The version is exactly one increment after the approved baseline.
[ ] All version references match.
[ ] The change log is updated.
[ ] Release notes are complete.
[ ] Automated checks pass.
[ ] Manual validation of all ready pages is complete.
[ ] No unsupported formulas or recommendations were introduced.
[ ] Incomplete features remain marked Udev.
[ ] Secrets and local environment files are excluded from Git.
[ ] The ZIP extracts correctly.
[ ] Windows setup and run scripts work.
[ ] The Git tag matches the application version.
[ ] The checkpoint result is recorded.
[ ] The Product Owner approves baseline promotion.
```

---

## 26. Git Tagging

After `v0.4` is approved:

```bat
git tag -a v0.4 -m "AI Infrastructure Sizing Platform v0.4"
git push origin v0.4
```

Do not tag a draft or blocked build as an approved release.

---

## 27. Change Log Template

```markdown
## v0.X - YYYY-MM-DD

Status:
Checkpoint:
Previous Baseline:

### Added
- New features.

### Changed
- Updated behavior.

### Fixed
- Corrected defects.

### Udev
- Features still under development.

### Known Limitations
- Confirmed limitations.

### Validation
- Tests completed.

### Open Actions
- Non-blocking actions for the next release.

### Approval
- Product Owner:
- Approval Date:
```

---

## 28. Current Version Record

```text
Application:              AI Infrastructure Sizing Platform
Current Approved Baseline: v0.3
Next Planned Version:      v0.4
Version Owner:             Product Owner
Version Rule:              Sequential increments only
Production Target:         v1.0 after all readiness gates pass
```

---

## 29. Final Control Rule

No developer, automation process, or generated package may independently change or skip the approved application version.

The current approved baseline remains `v0.3` until `v0.4` is explicitly reviewed and approved.
