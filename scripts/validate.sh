#!/usr/bin/env bash
# CompanyOS Deterministic Validation Gate (Linux/macOS)
# Auto-detects project tech stack and runs appropriate checks.
# Returns exit 0 on success, exit 1 on failure.

set -euo pipefail

echo "========================================"
echo " CompanyOS Deterministic Validation Gate"
echo " OS: $(uname -s) ($(uname -m))"
echo " Time: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "========================================"
echo ""

FAIL=0
RESULTS=""

# --- Tech Stack Detection ---
detect_stack() {
    if [ -f "package.json" ]; then echo "node"; return; fi
    if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then echo "python"; return; fi
    if [ -f "Cargo.toml" ]; then echo "rust"; return; fi
    if [ -f "go.mod" ]; then echo "go"; return; fi
    if [ -f "pom.xml" ] || [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then echo "java"; return; fi
    echo "unknown"
}

STACK=$(detect_stack)
echo "[INFO] Detected tech stack: $STACK"
echo ""

# --- Step 1: Linting ---
run_lint() {
    echo "-> Step 1: Linting..."
    case "$STACK" in
        node)
            if command -v npx &>/dev/null && [ -f "package.json" ]; then
                if grep -q '"lint"' package.json 2>/dev/null; then
                    npm run lint 2>&1 || return 1
                elif npx eslint --version &>/dev/null 2>&1; then
                    npx eslint . 2>&1 || return 1
                else
                    echo "   [SKIP] No lint script or eslint found"
                fi
            fi
            ;;
        python)
            if command -v ruff &>/dev/null; then
                ruff check . 2>&1 || return 1
            elif command -v flake8 &>/dev/null; then
                flake8 . 2>&1 || return 1
            elif command -v pylint &>/dev/null; then
                pylint --recursive=y . 2>&1 || return 1
            else
                echo "   [SKIP] No Python linter found (install ruff, flake8, or pylint)"
            fi
            ;;
        rust)
            cargo clippy -- -D warnings 2>&1 || return 1
            ;;
        go)
            if command -v golangci-lint &>/dev/null; then
                golangci-lint run 2>&1 || return 1
            else
                go vet ./... 2>&1 || return 1
            fi
            ;;
        java)
            echo "   [SKIP] Java linting (use IDE or checkstyle integration)"
            ;;
        *)
            echo "   [SKIP] Unknown stack, no linter configured"
            ;;
    esac
    return 0
}

if run_lint; then
    echo "   [PASS] Linting passed"
    RESULTS="$RESULTS\nLint: PASS"
else
    echo "   [FAIL] Linting failed"
    RESULTS="$RESULTS\nLint: FAIL"
    FAIL=1
fi
echo ""

# --- Step 2: Type Checking ---
run_typecheck() {
    echo "-> Step 2: Type Checking..."
    case "$STACK" in
        node)
            if [ -f "tsconfig.json" ]; then
                if grep -q '"typecheck"' package.json 2>/dev/null; then
                    npm run typecheck 2>&1 || return 1
                else
                    npx tsc --noEmit 2>&1 || return 1
                fi
            else
                echo "   [SKIP] No tsconfig.json (not a TypeScript project)"
            fi
            ;;
        python)
            if command -v mypy &>/dev/null; then
                mypy . 2>&1 || return 1
            elif command -v pyright &>/dev/null; then
                pyright 2>&1 || return 1
            else
                echo "   [SKIP] No Python type checker found (install mypy or pyright)"
            fi
            ;;
        rust)
            # Rust type checking happens during compilation
            echo "   [SKIP] Rust handles types at compile time (checked in build step)"
            ;;
        go)
            # Go type checking happens during compilation
            echo "   [SKIP] Go handles types at compile time (checked in build step)"
            ;;
        *)
            echo "   [SKIP] No type checker configured"
            ;;
    esac
    return 0
}

if run_typecheck; then
    echo "   [PASS] Type checking passed"
    RESULTS="$RESULTS\nTypecheck: PASS"
else
    echo "   [FAIL] Type checking failed"
    RESULTS="$RESULTS\nTypecheck: FAIL"
    FAIL=1
fi
echo ""

# --- Step 3: Build ---
run_build() {
    echo "-> Step 3: Build..."
    case "$STACK" in
        node)
            if grep -q '"build"' package.json 2>/dev/null; then
                npm run build 2>&1 || return 1
            else
                echo "   [SKIP] No build script in package.json"
            fi
            ;;
        python)
            # Python doesn't typically need a build step
            python -m py_compile $(find . -name "*.py" -not -path "./.venv/*" -not -path "./node_modules/*" | head -50) 2>&1 || return 1
            ;;
        rust)
            cargo build 2>&1 || return 1
            ;;
        go)
            go build ./... 2>&1 || return 1
            ;;
        java)
            if [ -f "pom.xml" ]; then
                mvn compile 2>&1 || return 1
            elif [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
                ./gradlew build 2>&1 || return 1
            fi
            ;;
        *)
            echo "   [SKIP] No build step configured"
            ;;
    esac
    return 0
}

if run_build; then
    echo "   [PASS] Build passed"
    RESULTS="$RESULTS\nBuild: PASS"
else
    echo "   [FAIL] Build failed"
    RESULTS="$RESULTS\nBuild: FAIL"
    FAIL=1
fi
echo ""

# --- Step 4: Tests ---
run_tests() {
    echo "-> Step 4: Running Tests..."
    case "$STACK" in
        node)
            if grep -q '"test"' package.json 2>/dev/null; then
                npm test 2>&1 || return 1
            else
                echo "   [SKIP] No test script in package.json"
            fi
            ;;
        python)
            if command -v pytest &>/dev/null; then
                pytest 2>&1 || return 1
            elif [ -d "tests" ]; then
                python -m unittest discover -s tests 2>&1 || return 1
            else
                echo "   [SKIP] No test framework or tests/ directory found"
            fi
            ;;
        rust)
            cargo test 2>&1 || return 1
            ;;
        go)
            go test ./... 2>&1 || return 1
            ;;
        java)
            if [ -f "pom.xml" ]; then
                mvn test 2>&1 || return 1
            elif [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
                ./gradlew test 2>&1 || return 1
            fi
            ;;
        *)
            echo "   [SKIP] No test runner configured"
            ;;
    esac
    return 0
}

if run_tests; then
    echo "   [PASS] Tests passed"
    RESULTS="$RESULTS\nTests: PASS"
else
    echo "   [FAIL] Tests failed"
    RESULTS="$RESULTS\nTests: FAIL"
    FAIL=1
fi
echo ""

# --- Step 5: Security Scan (basic) ---
run_security() {
    echo "-> Step 5: Dependency Security Scan..."
    case "$STACK" in
        node)
            npm audit --audit-level=high 2>&1 || echo "   [WARN] npm audit found issues"
            ;;
        python)
            if command -v pip-audit &>/dev/null; then
                pip-audit 2>&1 || echo "   [WARN] pip-audit found issues"
            elif command -v safety &>/dev/null; then
                safety check 2>&1 || echo "   [WARN] safety check found issues"
            else
                echo "   [SKIP] No Python security scanner (install pip-audit)"
            fi
            ;;
        rust)
            if command -v cargo-audit &>/dev/null; then
                cargo audit 2>&1 || echo "   [WARN] cargo audit found issues"
            else
                echo "   [SKIP] No cargo-audit installed"
            fi
            ;;
        *)
            echo "   [SKIP] No security scanner configured"
            ;;
    esac
    # Security scan is advisory, don't fail the gate
    RESULTS="$RESULTS\nSecurity: ADVISORY"
}

run_security
echo ""

# --- Summary ---
echo "========================================"
echo " VALIDATION SUMMARY"
echo "========================================"
echo -e "$RESULTS"
echo ""

if [ "$FAIL" -eq 0 ]; then
    echo "[SUCCESS] All deterministic checks passed! Awaiting Engineer Review."
    exit 0
else
    echo "[FAILURE] One or more checks failed. Route context back to Build Agent."
    exit 1
fi
