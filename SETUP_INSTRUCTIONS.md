# Fromza EMR - Complete Development Environment Setup Guide

## 🎯 Overview
This is an Enterprise Hospital Management System (EMR/HMS) built with:
- **Backend**: ASP.NET Core 1.1+ (C#)
- **Frontend**: Angular 7
- **Database**: SQL Server (Express or Developer Edition)
- **Dependencies**: Node.js v14.x, .NET SDK, SQL Server

---

## ⚡ Quick Setup (Copy-Paste into Copilot/AI Assistant)

**If you're using Cursor, Windsurf, Copilot, or any AI-powered IDE:**

Copy and paste this entire block into the AI chat:

```
Please help me set up this Fromza EMR hospital management system project. Here's what needs to be done:

1. **Verify Prerequisites**: Check that I have:
   - SQL Server Express or Developer Edition installed (or Microsoft SQL LocalDB)
   - .NET SDK 4.6.1+ or .NET Core 2.0+ 
   - Node.js v14.x (CRITICAL: Not v16+, must be v14 for Angular 7 compatibility)
   - Visual Studio 2017+ or VS Code with C# extension

2. **Set Up Databases**:
   - Restore the EMR database backup from "Database/2. EMR-Db/FromzaInternationalDB/Dev_DanpheEMR_INT1.bak" to SQL Server as "DEV_FromzaEMR_INT"
   - Run the SQL script at "Database/1. Admin-Db/1. FromzaAdmin_CompleteDB.sql" to create the "FromzaAdmin" database
   - Execute this query to reset admin password: UPDATE RBAC_User SET Password = 'b/ECdMP/loE=' WHERE UserName = 'admin' OR UserName = 'Admin';
   - (Password will be: admin / pass123)

3. **Configure Connection Strings**:
   - Open "Code/Websites/FromzaEMR/appsettings.json"
   - Verify these connection strings point to your SQL Server instance:
     - "Connectionstring": "Data Source=localhost;Initial Catalog=DEV_FromzaEMR_INT;Integrated Security=True;MultipleActiveResultSets=true;TrustServerCertificate=True"
     - "ConnectionStringAdmin": "Data Source=localhost; Initial Catalog=FromzaAdmin; Integrated Security=True;TrustServerCertificate=True"

4. **Install Frontend Dependencies**:
   - Open terminal and go to: Code/Websites/FromzaEMR/wwwroot/FromzaApp
   - Run: npm install
   - Start dev server: npm start
   - Frontend will run on http://localhost:4200

5. **Start Backend Server**:
   - Open new terminal in: Code/Websites/FromzaEMR
   - Run: dotnet build and then dotnet run (or use kill_and_build.cmd)
   - Backend will run on http://localhost:5000

6. **Verify Setup**:
   - Visit http://localhost:5000 in browser
   - Login with: admin / pass123
   - You should see the EMR dashboard

Help me through each step and let me know if you encounter any errors.
```

---

## 📋 Manual Step-by-Step Setup

### **Step 1: Install Prerequisites**

Check you have these installed on your system:

#### A. SQL Server
- **Option 1**: SQL Server Express (Free) - [Download](https://www.microsoft.com/sql-server/sql-server-downloads)
- **Option 2**: SQL Server Developer Edition - [Download](https://www.microsoft.com/sql-server/sql-server-downloads)
- **Option 3**: LocalDB (lightweight, included with Visual Studio)

Verify installation:
```powershell
# In PowerShell, check if SQL is running
sqlcmd -S localhost -Q "SELECT @@VERSION"
```

#### B. .NET SDK
- Download [.NET SDK 4.6.1+](https://www.microsoft.com/net/download) or [.NET Core 2.0+](https://dotnet.microsoft.com/download/dotnet)

Verify:
```powershell
dotnet --version
```

#### C. Node.js v14 ⚠️ (CRITICAL - Must be v14, NOT v16+)
- Download [Node.js v14.x](https://nodejs.org/en/download/releases/) (LTS - v14.21.3 recommended)
- **Do NOT use v16+ as it's incompatible with Angular 7**
- ⚠️ **If you have Node v16+ installed globally, you MUST either:**
  - Uninstall newer versions and use ONLY v14, OR
  - Use [NVM](https://github.com/nvm-sh/nvm-windows) (Node Version Manager) to switch versions

Verify:
```powershell
node --version  # Should show v14.x.x (NOT v16, v18, v20, etc.)
npm --version
```

#### D. Visual Studio Code or Visual Studio
- [VS Code](https://code.visualstudio.com/) (recommended) + C# extension
- OR [Visual Studio 2017+](https://visualstudio.microsoft.com/)

---

### **Step 2: Restore Databases**

#### A. Restore EMR Database
1. Open **SQL Server Management Studio (SSMS)** or use SQL PowerShell
2. Navigate to the backup file:
   ```
   Database/2. EMR-Db/FromzaInternationalDB/Dev_DanpheEMR_INT1.bak
   ```
3. Restore it with database name: `DEV_FromzaEMR_INT`

**Using SSMS:**
- Right-click "Databases" → "Restore Database..."
- Select "Device" → browse to `.bak` file
- Set database name to `DEV_FromzaEMR_INT`
- Click "OK"

**Using PowerShell:**
```powershell
$backupPath = "Database/2. EMR-Db/FromzaInternationalDB/Dev_DanpheEMR_INT1.bak"
$restoreQuery = @"
RESTORE DATABASE [DEV_FromzaEMR_INT]
FROM DISK = N'$backupPath'
WITH MOVE 'DanpheEMR_Data' TO 'C:\Databases\DEV_FromzaEMR_INT.mdf',
     MOVE 'DanpheEMR_Log' TO 'C:\Databases\DEV_FromzaEMR_INT.ldf'
"@
sqlcmd -S localhost -Q $restoreQuery
```

#### B. Create Admin Database
1. Open SSMS or command line
2. Run the SQL script:
   ```
   Database/1. Admin-Db/1. FromzaAdmin_CompleteDB.sql
   ```

**Using SSMS:**
- File → "Open File" → select the `.sql` file
- Click "Execute"

**Using PowerShell:**
```powershell
sqlcmd -S localhost -i "Database/1. Admin-Db/1. FromzaAdmin_CompleteDB.sql"
```

#### C. Reset Admin User Password
Run this query on `DEV_FromzaEMR_INT`:
```sql
UPDATE RBAC_User 
SET Password = 'b/ECdMP/loE=' 
WHERE UserName = 'admin' OR UserName = 'Admin';
```
**Default credentials after reset: `admin` / `pass123`**

---

### **Step 3: Configure Connection Strings**

1. Open: `Code/Websites/FromzaEMR/appsettings.json`
2. Verify the connection strings (should already be configured):
   ```json
   {
     "Connectionstring": "Data Source=localhost;Initial Catalog=DEV_FromzaEMR_INT;Integrated Security=True;MultipleActiveResultSets=true;TrustServerCertificate=True",
     "ConnectionStringAdmin": "Data Source=localhost; Initial Catalog=FromzaAdmin; Integrated Security=True;TrustServerCertificate=True"
   }
   ```

**If using SQL Authentication instead of Windows Auth, update to:**
```json
{
  "Connectionstring": "Data Source=localhost;Initial Catalog=DEV_FromzaEMR_INT;User Id=sa;Password=YourPassword;MultipleActiveResultSets=true;TrustServerCertificate=True",
  "ConnectionStringAdmin": "Data Source=localhost;Initial Catalog=FromzaAdmin;User Id=sa;Password=YourPassword;TrustServerCertificate=True"
}
```

---

### **Step 4: Install Frontend Dependencies (Resolve Modern vs Old Dependency Conflicts)**

1. Open terminal/PowerShell
2. Navigate to frontend directory:
   ```powershell
   cd Code/Websites/FromzaEMR/wwwroot/FromzaApp
   ```

3. Verify Node v14 is active:
   ```powershell
   node --version  # Must show v14.x.x (NOT v16+)
   ```
   - **If it shows v16 or higher, STOP and switch to v14 using NVM or uninstall the newer version**

4. **Clean Old Dependencies (CRITICAL - do this to prevent conflicts)**:
   ```powershell
   # Clear npm cache
   npm cache clean --force
   
   # Remove old dependencies
   Remove-Item -Recurse -Force node_modules -ErrorAction SilentlyContinue
   Remove-Item -Force package-lock.json -ErrorAction SilentlyContinue
   ```
   *(This prevents modern packages from conflicting with Angular 7's old dependencies)*

5. Install dependencies:
   ```powershell
   npm install
   ```
   *(This may take 3-5 minutes)*
   - **Expected**: You may see peer dependency warnings - this is NORMAL for Angular 7
   - **If npm shows errors**, try: `npm install --legacy-peer-deps`

6. Start development server:
   ```powershell
   npm start
   ```
   - Frontend will run on: **http://localhost:4200**
   - Keep this terminal open

---

### **Step 5: Start Backend Server**

1. Open a **NEW** terminal/PowerShell window
2. Navigate to backend directory:
   ```powershell
   cd Code/Websites/FromzaEMR
   ```

3. Build and run the backend:
   ```powershell
   # Option A: Using the provided script
   .\kill_and_build.cmd
   
   # Option B: Manual build and run
   dotnet build
   dotnet run
   ```
   - Backend will run on: **http://localhost:5000**
   - Keep this terminal open

---

### **Step 6: Verify Everything is Working**

1. Open browser and go to: **http://localhost:5000**
2. Login with credentials:
   - **Username**: `admin`
   - **Password**: `pass123`
3. You should see the EMR dashboard with Hospital Management options

**If something doesn't work:**
- Check both terminals are still running
- Verify SQL databases are accessible
- Ensure ports 4200 (frontend) and 5000 (backend) are not blocked
- Check firewall settings
- Review error messages in terminal windows

---

## 🐛 Troubleshooting

### "npm install fails with dependency conflicts" (Most Common)

**Cause**: Modern npm packages conflict with Angular 7's old dependencies

**Solution**:
```powershell
# 1. Verify Node v14
node --version  # MUST be v14.x.x

# 2. Clear cache and reinstall
npm cache clean --force
Remove-Item -Recurse -Force node_modules -ErrorAction SilentlyContinue
Remove-Item -Force package-lock.json -ErrorAction SilentlyContinue

# 3. Reinstall with legacy peer deps flag
npm install --legacy-peer-deps
```

**Why?** Angular 7 was released in 2018 and uses very old npm packages. Modern npm (v7+) enforces strict peer dependency checking, which breaks old projects. The `--legacy-peer-deps` flag tells npm to ignore these warnings.

### "Angular build fails after install"
```powershell
# Kill any running ng processes
taskkill /IM node.exe /F

# Clear npm cache again
npm cache clean --force

# Reinstall
Rm -Recurse -Force node_modules, package-lock.json
npm install --legacy-peer-deps

# Try again
npm start
```

### "Cannot connect to SQL Server"
```powershell
# Test SQL connection
sqlcmd -S localhost -Q "SELECT @@VERSION"
# If fails, SQL Server may not be running. Start it:
# In Services.msc, find "SQL Server (SQLEXPRESS)" and start it
```

### "npm start fails - Angular 7 not compatible with Node v16+" ⚠️ CRITICAL
```powershell
# Check which Node version is active
node --version

# If v16+:
# Option 1: Uninstall and reinstall Node v14 only
# Option 2: Use NVM to switch to v14
if (Get-Command nvm -ErrorAction SilentlyContinue) {
    nvm use 14
} else {
    # Download Node v14 from: https://nodejs.org/en/download/releases/
    Write-Host "Please install Node v14 from nodejs.org and uninstall v16+"
}

# After switching to v14, reinstall dependencies
Rm -Recurse -Force node_modules, package-lock.json
npm cache clean --force
npm install --legacy-peer-deps
npm start
```

### "Port 5000 already in use"
```powershell
# Kill process on port 5000
netstat -ano | findstr :5000
taskkill /PID <PID> /F
```

### ".NET SDK not found"
```powershell
# Download and install .NET SDK
# https://dotnet.microsoft.com/download/dotnet
dotnet --version  # Verify after install
```

### "Database backup file not found"
- Ensure you're in the correct directory with the project
- Check: `Database/2. EMR-Db/FromzaInternationalDB/Dev_DanpheEMR_INT1.bak`
- If missing, request from project maintainer

---

## 📞 Support

- **Backend API**: Runs on `http://localhost:5000`
- **Frontend**: Runs on `http://localhost:4200` (proxied to backend)
- **Default Admin Login**: `admin` / `pass123`
- **Database**: `DEV_FromzaEMR_INT` and `FromzaAdmin`

---

## ✅ Setup Checklist

- [ ] SQL Server installed and running
- [ ] .NET SDK 4.6.1+ or .NET Core 2.0+ installed
- [ ] Node.js v14.x installed (NOT v16+)
- [ ] EMR database restored (`DEV_FromzaEMR_INT`)
- [ ] Admin database created (`FromzaAdmin`)
- [ ] Admin password reset in database
- [ ] Connection strings configured in `appsettings.json`
- [ ] Frontend dependencies installed (`npm install`)
- [ ] Frontend running on `http://localhost:4200`
- [ ] Backend built and running on `http://localhost:5000`
- [ ] Successfully logged in with `admin` / `pass123`

---

**Once all items are checked, your development environment is ready! 🚀**
