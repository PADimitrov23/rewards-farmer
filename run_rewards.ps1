# run_rewards.ps1 — run from Task Scheduler
$ErrorActionPreference = 'Stop'

# go to repo root
Set-Location "C:\Random-clones\rewards-farmer"

# Environment variables — adjust as you want
$env:QUERY_SOURCE = "trends"                 # avoids ollama
$env:REWARDS_HEADLESS = "1"                 # set to "1" to run headless
$env:REWARDS_FARMER_LOG_LEVEL = "INFO"      # "DEBUG" for verbose logs
# timestamped log file (or use run.log to overwrite)
$logFile = Join-Path $PWD ("run_{0}.log" -f (Get-Date -Format "yyyyMMdd_HHmmss"))
$env:REWARDS_FARMER_LOG_FILE = $logFile

# Make msedgedriver accessible if you placed it in repo root
$env:Path = "$PWD;$env:Path"

# Use venv python directly (avoids activation side-effects)
$python = Join-Path $PWD ".venv\Scripts\python.exe"
if (-not (Test-Path $python)) {
    Write-Error "Python in .venv not found at $python. Create venv or adjust path."
    exit 1
}

# Run the script and redirect output to log file
& $python -u src/main.py *>&1 | Tee-Object -FilePath $logFile
exit $LASTEXITCODE