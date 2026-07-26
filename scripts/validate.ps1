# CompanyOS Deterministic Validation Gate (Windows)
# Auto-detects project tech stack and runs appropriate checks.
# Returns exit code 0 on success, 1 on failure.

param(
    [string]$ProjectPath = "."
)

$ErrorActionPreference = "Continue"

Write-Host "========================================"
Write-Host " CompanyOS Deterministic Validation Gate"
Write-Host " OS: Windows ($([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture))"
Write-Host " Time: $(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssZ')"
Write-Host "========================================"
Write-Host ""

Push-Location $ProjectPath

$Fail = 0
$Results = @()

# --- Tech Stack Detection ---
function Detect-Stack {
    if (Test-Path "package.json") { return "node" }
    if ((Test-Path "requirements.txt") -or (Test-Path "pyproject.toml") -or (Test-Path "setup.py")) { return "python" }
    if (Test-Path "Cargo.toml") { return "rust" }
    if (Test-Path "go.mod") { return "go" }
    if ((Test-Path "pom.xml") -or (Test-Path "build.gradle") -or (Test-Path "build.gradle.kts")) { return "java" }
    return "unknown"
}

$Stack = Detect-Stack
Write-Host "[INFO] Detected tech stack: $Stack"
Write-Host ""

# --- Step 1: Linting ---
Write-Host "-> Step 1: Linting..."
$LintPassed = $true
switch ($Stack) {
    "node" {
        if (Test-Path "package.json") {
            $pkg = Get-Content "package.json" -Raw
            if ($pkg -match '"lint"') {
                npm run lint 2>&1 | Write-Host
                if ($LASTEXITCODE -ne 0) { $LintPassed = $false }
            } elseif (Get-Command npx -ErrorAction SilentlyContinue) {
                npx eslint . 2>&1 | Write-Host
                if ($LASTEXITCODE -ne 0) { $LintPassed = $false }
            } else {
                Write-Host "   [SKIP] No lint script or eslint found"
            }
        }
    }
    "python" {
        if (Get-Command ruff -ErrorAction SilentlyContinue) {
            ruff check . 2>&1 | Write-Host
            if ($LASTEXITCODE -ne 0) { $LintPassed = $false }
        } elseif (Get-Command flake8 -ErrorAction SilentlyContinue) {
            flake8 . 2>&1 | Write-Host
            if ($LASTEXITCODE -ne 0) { $LintPassed = $false }
        } else {
            Write-Host "   [SKIP] No Python linter found (install ruff or flake8)"
        }
    }
    "rust" {
        cargo clippy -- -D warnings 2>&1 | Write-Host
        if ($LASTEXITCODE -ne 0) { $LintPassed = $false }
    }
    "go" {
        if (Get-Command golangci-lint -ErrorAction SilentlyContinue) {
            golangci-lint run 2>&1 | Write-Host
            if ($LASTEXITCODE -ne 0) { $LintPassed = $false }
        } else {
            go vet ./... 2>&1 | Write-Host
            if ($LASTEXITCODE -ne 0) { $LintPassed = $false }
        }
    }
    default {
        Write-Host "   [SKIP] Unknown stack, no linter configured"
    }
}
if ($LintPassed) {
    Write-Host "   [PASS] Linting passed"
    $Results += "Lint: PASS"
} else {
    Write-Host "   [FAIL] Linting failed"
    $Results += "Lint: FAIL"
    $Fail = 1
}
Write-Host ""

# --- Step 2: Type Checking ---
Write-Host "-> Step 2: Type Checking..."
$TypePassed = $true
switch ($Stack) {
    "node" {
        if (Test-Path "tsconfig.json") {
            $pkg = Get-Content "package.json" -Raw -ErrorAction SilentlyContinue
            if ($pkg -and $pkg -match '"typecheck"') {
                npm run typecheck 2>&1 | Write-Host
            } else {
                npx tsc --noEmit 2>&1 | Write-Host
            }
            if ($LASTEXITCODE -ne 0) { $TypePassed = $false }
        } else {
            Write-Host "   [SKIP] No tsconfig.json"
        }
    }
    "python" {
        if (Get-Command mypy -ErrorAction SilentlyContinue) {
            mypy . 2>&1 | Write-Host
            if ($LASTEXITCODE -ne 0) { $TypePassed = $false }
        } elseif (Get-Command pyright -ErrorAction SilentlyContinue) {
            pyright 2>&1 | Write-Host
            if ($LASTEXITCODE -ne 0) { $TypePassed = $false }
        } else {
            Write-Host "   [SKIP] No type checker found"
        }
    }
    "rust" { Write-Host "   [SKIP] Rust types checked at compile time" }
    "go" { Write-Host "   [SKIP] Go types checked at compile time" }
    default { Write-Host "   [SKIP] No type checker configured" }
}
if ($TypePassed) {
    Write-Host "   [PASS] Type checking passed"
    $Results += "Typecheck: PASS"
} else {
    Write-Host "   [FAIL] Type checking failed"
    $Results += "Typecheck: FAIL"
    $Fail = 1
}
Write-Host ""

# --- Step 3: Build ---
Write-Host "-> Step 3: Build..."
$BuildPassed = $true
switch ($Stack) {
    "node" {
        $pkg = Get-Content "package.json" -Raw -ErrorAction SilentlyContinue
        if ($pkg -and $pkg -match '"build"') {
            npm run build 2>&1 | Write-Host
            if ($LASTEXITCODE -ne 0) { $BuildPassed = $false }
        } else {
            Write-Host "   [SKIP] No build script"
        }
    }
    "python" {
        $pyFiles = Get-ChildItem -Path . -Filter "*.py" -Recurse |
                   Where-Object { $_.FullName -notmatch '\.venv|node_modules|__pycache__' } |
                   Select-Object -First 50
        foreach ($f in $pyFiles) {
            python -m py_compile $f.FullName 2>&1 | Write-Host
            if ($LASTEXITCODE -ne 0) { $BuildPassed = $false; break }
        }
    }
    "rust" {
        cargo build 2>&1 | Write-Host
        if ($LASTEXITCODE -ne 0) { $BuildPassed = $false }
    }
    "go" {
        go build ./... 2>&1 | Write-Host
        if ($LASTEXITCODE -ne 0) { $BuildPassed = $false }
    }
    "java" {
        if (Test-Path "pom.xml") {
            mvn compile 2>&1 | Write-Host
            if ($LASTEXITCODE -ne 0) { $BuildPassed = $false }
        } elseif ((Test-Path "build.gradle") -or (Test-Path "build.gradle.kts")) {
            .\gradlew build 2>&1 | Write-Host
            if ($LASTEXITCODE -ne 0) { $BuildPassed = $false }
        }
    }
    default { Write-Host "   [SKIP] No build step configured" }
}
if ($BuildPassed) {
    Write-Host "   [PASS] Build passed"
    $Results += "Build: PASS"
} else {
    Write-Host "   [FAIL] Build failed"
    $Results += "Build: FAIL"
    $Fail = 1
}
Write-Host ""

# --- Step 4: Tests ---
Write-Host "-> Step 4: Running Tests..."
$TestPassed = $true
switch ($Stack) {
    "node" {
        $pkg = Get-Content "package.json" -Raw -ErrorAction SilentlyContinue
        if ($pkg -and $pkg -match '"test"') {
            npm test 2>&1 | Write-Host
            if ($LASTEXITCODE -ne 0) { $TestPassed = $false }
        } else {
            Write-Host "   [SKIP] No test script"
        }
    }
    "python" {
        if (Get-Command pytest -ErrorAction SilentlyContinue) {
            pytest 2>&1 | Write-Host
            if ($LASTEXITCODE -ne 0) { $TestPassed = $false }
        } elseif (Test-Path "tests") {
            python -m unittest discover -s tests 2>&1 | Write-Host
            if ($LASTEXITCODE -ne 0) { $TestPassed = $false }
        } else {
            Write-Host "   [SKIP] No test framework found"
        }
    }
    "rust" {
        cargo test 2>&1 | Write-Host
        if ($LASTEXITCODE -ne 0) { $TestPassed = $false }
    }
    "go" {
        go test ./... 2>&1 | Write-Host
        if ($LASTEXITCODE -ne 0) { $TestPassed = $false }
    }
    default { Write-Host "   [SKIP] No test runner configured" }
}
if ($TestPassed) {
    Write-Host "   [PASS] Tests passed"
    $Results += "Tests: PASS"
} else {
    Write-Host "   [FAIL] Tests failed"
    $Results += "Tests: FAIL"
    $Fail = 1
}
Write-Host ""

# --- Step 5: Security Scan ---
Write-Host "-> Step 5: Dependency Security Scan..."
switch ($Stack) {
    "node" {
        npm audit --audit-level=high 2>&1 | Write-Host
        Write-Host "   [ADVISORY] npm audit complete"
    }
    "python" {
        if (Get-Command pip-audit -ErrorAction SilentlyContinue) {
            pip-audit 2>&1 | Write-Host
        } else {
            Write-Host "   [SKIP] No pip-audit installed"
        }
    }
    "rust" {
        if (Get-Command cargo-audit -ErrorAction SilentlyContinue) {
            cargo audit 2>&1 | Write-Host
        } else {
            Write-Host "   [SKIP] No cargo-audit installed"
        }
    }
    default { Write-Host "   [SKIP] No security scanner configured" }
}
$Results += "Security: ADVISORY"
Write-Host ""

# --- Summary ---
Write-Host "========================================"
Write-Host " VALIDATION SUMMARY"
Write-Host "========================================"
$Results | ForEach-Object { Write-Host $_ }
Write-Host ""

Pop-Location

if ($Fail -eq 0) {
    Write-Host "[SUCCESS] All deterministic checks passed! Awaiting Engineer Review."
    exit 0
} else {
    Write-Host "[FAILURE] One or more checks failed. Route context back to Build Agent."
    exit 1
}
