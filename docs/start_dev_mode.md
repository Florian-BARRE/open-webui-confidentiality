# 🛠️ Updating a Forked OpenWebUI Project While Preserving Local Changes

This guide describes how to update a fork of the OpenWebUI project by merging the latest changes from the official repository, while keeping local modifications and preserving essential data.

---

## 📁 1. Backup of Local Data

Before applying any update, it is recommended to back up the local data directory to avoid any potential data loss.

```bash
cp -r ./backend/data/ ~/openwebui_data_backup/
```

This backup allows the original data to be restored after the update process is completed.

---

## 🔀 2. Merge the Latest Changes from the Official Repository

To integrate the latest improvements and updates from the original OpenWebUI project, the following steps should be followed.

### Step 1: Add the original repository as a remote (only once)
```bash
git remote add upstream https://github.com/open-webui/open-webui.git
```

### Step 2: Fetch the latest changes from upstream
```bash
git fetch upstream
```

### Step 3: Create a temporary branch to handle the merge
```bash
git checkout -b merge-upstream
```

This ensures that the working branch remains clean in case the merge needs to be redone.

### Step 4: Merge the official `main` branch
```bash
git merge upstream/main
```

If conflicts occur during the merge, they must be resolved manually using an appropriate code editor such as Visual Studio Code.

#### Conflict Resolution (via VS Code)

During the conflict resolution phase:
- **Current Change** refers to the local version (the fork).
- **Incoming Change** refers to the upstream version (the official project).

One can:
- Keep the current version,
- Accept the incoming version,
- Or manually merge both, depending on the context.

### Step 5: Verify that the project functions correctly

At this stage, the application should be tested to ensure compatibility between local modifications and upstream changes.

---

## ♻️ 3. Restore the Local Data Directory

Once the update is confirmed to be successful, the original data directory can be restored:

```bash
cp -r ~/openwebui_data_backup/* ./backend/data/
```

---

## 📦 4. Reinstall Project Dependencies

After the codebase is updated, dependencies must be reinstalled to ensure compatibility:

```bash
npm install
```

---

## 🚀 5. Run the Application

### Frontend

From the root directory of the project, the frontend can be launched using:

```bash
npm run dev
```

This command starts the frontend development server (typically available at http://localhost:3000).

---

### Backend

From the `backend` directory, the backend environment should be activated and launched as follows:

```bash
cd backend
conda activate open-webui
```

Then, start the backend server using:

```bash
uvicorn open_webui.main:app --port 8080 --host 0.0.0.0 --forwarded-allow-ips '*' --reload
```

---

## ✅ Summary

| Step | Description |
|------|-------------|
| 1 | Back up the `./backend/data/` directory |
| 2 | Add and fetch the latest upstream updates |
| 3 | Create a temporary branch for merging |
| 4 | Merge `upstream/main` into the current branch and resolve conflicts |
| 5 | Test the application |
| 6 | Restore the local data |
| 7 | Run `npm install` to update dependencies |
| 8 | Start the frontend and backend servers |

