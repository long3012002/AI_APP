Write-Host "=== SETUP AI APP (YOLOv8 + FastAPI + React) ON WINDOWS ===" -ForegroundColor Cyan

# 1. Check Python
Write-Host "`n[1/8] Checking Python..."
$pythonVersion = python --version 2>$null
if (-not $pythonVersion) {
    Write-Host "Python not found! Please install Python 3.10 and 3.12" -ForegroundColor Red
    exit
}
Write-Host ("Python OK: " + $pythonVersion)

# 2. Create venv
Write-Host "`n[2/8] Creating Python virtual environment..."
python -m venv venv
if (-Not (Test-Path "venv")) {
    Write-Host "Failed to create virtual environment!" -ForegroundColor Red
    exit
}
Write-Host "Activating environment..."
.\venv\Scripts\activate

# 3. Install backend dependencies
Write-Host "`n[3/8] Installing backend dependencies (Ultralytics, FastAPI)..."
pip install --upgrade pip
pip install ultralytics fastapi uvicorn python-multipart pillow
Write-Host "Backend dependencies installed!"

# 4. Check Node.js
Write-Host "`n[4/8] Checking Node.js and npm..."
$nodeVersion = node --version 2>$null
if (-not $nodeVersion) {
    Write-Host "Node.js not found! Install from https://nodejs.org" -ForegroundColor Red
    exit
}
Write-Host ("Node OK: " + $nodeVersion)

# 5. Install frontend
Write-Host "`n[5/8] Installing frontend packages..."
cd frontend
npm install
Write-Host "`n[6/8] Building frontend..."
npm run build
cd ..

# 6. Copy frontend build to backend/static
Write-Host "`n[7/8] Copying frontend build to backend/static..."
$dest = "backend/static"
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
Copy-Item "frontend/dist" $dest -Recurse
Write-Host "Frontend build copied successfully!"

# 7. Run backend
Write-Host "`n[8/8] Starting backend server..."
Write-Host "Your API will be live at: http://127.0.0.1:8000"
Write-Host "Press CTRL + C to stop."
uvicorn backend.main:app --reload
