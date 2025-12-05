# ============================
#  SETUP YOLO + ULTRALYTICS
# ============================

Write-Host "=== Checking Python ==="

# Kiểm tra Python
$python = Get-Command python -ErrorAction SilentlyContinue

if (-not $python) {
    Write-Host "Python chưa cài hoặc chưa được thêm vào PATH!" -ForegroundColor Red
    exit
}

Write-Host "Python found at: $($python.Source)" -ForegroundColor Green

# Tạo virtual environment
Write-Host "=== Creating virtual environment ==="
python -m venv yolo_env

if (-not (Test-Path "./yolo_env")) {
    Write-Host "Không thể tạo virtual environment!" -ForegroundColor Red
    exit
}

Write-Host "Virtual env created!" -ForegroundColor Green

# Activate venv
Write-Host "=== Activating virtual environment ==="
Set-ExecutionPolicy Bypass -Scope Process -Force
.\yolo_env\Scripts\Activate.ps1

Write-Host "Virtual environment activated!" -ForegroundColor Green

# Upgrade pip
Write-Host "=== Upgrading pip ==="
pip install --upgrade pip

# Cài ultralytics
Write-Host "=== Installing ultralytics ==="
pip install ultralytics

if ($LASTEXITCODE -ne 0) {
    Write-Host "Cài đặt ultralytics thất bại!" -ForegroundColor Red
    exit
}

Write-Host "Ultralytics installed successfully!" -ForegroundColor Green

# Cài dependency
pip install opencv-python pillow numpy matplotli
