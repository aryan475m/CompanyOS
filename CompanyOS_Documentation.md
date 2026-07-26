# CompanyOS — Enterprise Agentic Orchestration System

## Complete System Documentation

---

## Table of Contents

1. [What Is CompanyOS](#1-what-is-companyos)
2. [Philosophy & Origin](#2-philosophy--origin)
3. [Architecture Overview](#3-architecture-overview)
4. [How It Works: The SDLC Pipeline](#4-how-it-works-the-sdlc-pipeline)
5. [Agent Roster & Constitutions](#5-agent-roster--constitutions)
6. [Domain-Adaptive Intelligence](#6-domain-adaptive-intelligence)
7. [Multi-Company Collaboration](#7-multi-company-collaboration)
8. [Force Sizing & Task Classification](#8-force-sizing--task-classification)
9. [Cross-OS Support](#9-cross-os-support)
10. [Deterministic Validation Gate](#10-deterministic-validation-gate)
11. [File Structure & Installation](#11-file-structure--installation)
12. [Usage Examples](#12-usage-examples)
13. [Artifact Handoff Protocol](#13-artifact-handoff-protocol)
14. [Error Recovery & Self-Healing](#14-error-recovery--self-healing)
15. [Customization & Extension](#15-customization--extension)
16. [Troubleshooting](#16-troubleshooting)

---

## 1. What Is CompanyOS

CompanyOS is an **Antigravity skill** that transforms a single natural-language prompt into a fully autonomous software development operation. It deploys a team of specialized AI agents — each with strict role boundaries, isolated sandboxes, and artifact handoff protocols — that collectively execute a complete Software Development Life Cycle (SDLC).

**You provide:** A prompt describing what you want built.  
**CompanyOS handles:** Everything else — market research, architecture, coding, security auditing, testing, and documentation.

### Key Differentiators

- **Industry-Agnostic**: Not limited to tech companies. Works for finance, astronomy, biotech, defense, energy, education, or any domain. The system detects the industry from your prompt and injects domain-specific knowledge into every agent.
- **Multi-Company Collaboration**: Projects spanning multiple domains spin up isolated "company" teams that collaborate through shared specifications — like real-world joint ventures.
- **Dynamic Force Sizing**: A CSS fix doesn't need 7 agents. CompanyOS calibrates team size and model weights to the task complexity.
- **Cross-Platform**: Works identically on Windows, Linux, and macOS.
- **Zero User Intervention**: After the initial prompt, agents handle all coordination, error recovery, and handoffs autonomously.

---

## 2. Philosophy & Origin

CompanyOS is built on the **Agentic Engineering** philosophy (credit: IndyDevDan), which rejects "Loop Engineering" — the naive approach of one agent writing code, running tests, and looping on itself.

### The Three Actors of Value Creation

| Actor | Role | Cost | Reliability |
|-------|------|------|-------------|
| **Engineers** (You) | Meta-engineering: design the system that builds the system | Your time | Perfect intent, limited bandwidth |
| **Agents** (LLM Compute) | Specialized reasoning, code generation, analysis | Tokens | Creative but can hallucinate |
| **Code** (Deterministic Logic) | Linting, compiling, testing, formatting, validation | Zero tokens | Perfect reliability, zero hallucination |

### Core Principles

1. **Separation of Concerns**: Never bundle agent reasoning with deterministic validation in the same prompt. Agents write code; deterministic scripts validate it.
2. **Agent Sandboxing**: Each agent is locked to its own directory. A backend agent cannot touch frontend files. This prevents merge conflicts and hallucinated dependencies.
3. **Spec-Driven Artifact Handoffs**: Agents communicate through documents, not direct calls. The architect writes an API spec; the backend engineer reads it and implements accordingly. This is how real companies operate.
4. **The Software Factory**: Instead of one general-purpose agent, specialized workflows route tasks to the right agent configuration. A chore doesn't need the full SDLC; a hotfix prioritizes speed over architectural perfection.

---

## 3. Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     USER PROMPT                                  │
│  "Build a satellite data analytics platform for trading"         │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                   CEO / ORCHESTRATOR                              │
│  (CompanyOS SKILL.md — the brain)                                │
│                                                                   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                       │
│  │ Domain   │  │ Task     │  │ Force    │                       │
│  │ Detect   │  │ Classify │  │ Size     │                       │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘                       │
│       └──────────────┴─────────────┘                             │
│                      │                                            │
│              Battle Plan (Phase 0)                                │
└──────────────────────┬──────────────────────────────────────────┘
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
   ┌─────────┐  ┌──────────┐  ┌──────────┐
   │ Single  │  │ Standard │  │ Multi-   │
   │ Company │  │ SDLC     │  │ Company  │
   │ (simple)│  │ Pipeline │  │ Collab   │
   └────┬────┘  └────┬─────┘  └────┬─────┘
        │             │             │
        ▼             ▼             ▼
   Phase 1-6     Phase 1-6    Phase 1-6 × N
   (selective)   (full)       (per company)
                              + Integration
```

---

## 4. How It Works: The SDLC Pipeline

### Phase 0: Prompt Analysis & Battle Plan

The orchestrator reads your prompt and produces `docs/00-battle-plan.md`:
- **Domain Detection**: What industry is this? (Tech, Finance, Astronomy, etc.)
- **Task Classification**: How complex is this? (Chore → Bug → Feature → Product)
- **Force Sizing**: How many agents, which roles, what model weights?
- **Collaboration Detection**: Does this need multiple "companies"?
- **Phase Selection**: Which phases to run, which to skip?

### Phase 1: Requirements & Market Research

Agent `@MarketResearcher` analyzes the prompt and produces `docs/01-market-requirements.md`:
- Target audience definition
- Core feature list with priorities
- Success metrics and KPIs
- Competitive landscape analysis
- Domain-specific compliance requirements (if applicable)

**The agent never writes code.** Its only output is the requirements document.

### Phase 2: Architecture & System Design

Agent `@ArchitectDB` reads the requirements and produces:
- `docs/02-architecture.md` — full system design
- `docs/02-api-contracts.json` — strict API specifications
- `docs/02-db-schema.sql` — database design

The architect defines the rules that all engineers must follow. API contracts are the "contract" between frontend and backend — they can develop in parallel without stepping on each other.

### Phase 3: Parallel Engineering (The Sandbox)

Multiple engineering agents deploy concurrently, each locked to their directory:

| Agent | Sandbox | What They Build |
|-------|---------|-----------------|
| `@BackendEngineer` | `src/backend/` | Server-side logic, APIs, database integration |
| `@FrontendEngineer` | `src/frontend/` | UI components, client-side logic, API consumption |
| `@DataEngineer` | `src/data/` | ETL pipelines, data ingestion (only if needed) |

**Sandbox enforcement is absolute.** A backend agent writing to `src/frontend/` is a violation. If the backend isn't ready, the frontend uses mock data based on the API contracts.

### Phase 4: Security Hardening (Red/Blue Team)

Agent `@CybersecRedBlue` acts as both attacker and defender:

**Red Team (Attack):**
- OWASP Top 10 vulnerability hunting
- Hardcoded secret detection
- Injection flaw analysis
- Broken access control checks
- Domain-specific threats (e.g., transaction integrity for finance, PHI exposure for healthcare)

**Blue Team (Defend):**
- Patches every vulnerability found
- Adds input validation at trust boundaries
- Ensures proper encryption
- Outputs `docs/03-security-audit.md` with full findings

### Phase 5: QA & Validation Loop

Agent `@QATester` writes and executes tests, then runs the deterministic validation script:
1. Writes unit and integration tests based on the requirements
2. Executes the test suite
3. Runs `validate.ps1` (Windows) or `validate.sh` (Linux/macOS)
4. If anything fails → the orchestrator routes the error to the responsible engineer
5. The engineer fixes → QA re-runs → loop until green (max 3 iterations)

### Phase 6: Documentation & Delivery

Agent `@TechnicalWriter` produces:
- `README.md` — complete project documentation
- `.env.example` — environment variable template
- `DEPLOYMENT.md` — deployment instructions (if applicable)

---

## 5. Agent Roster & Constitutions

### Core Agents (Always Available)

#### @MarketResearcher
- **Title**: Senior Business & Requirements Analyst
- **Sandbox**: `docs/` (write), entire project (read)
- **Rules**: Never write code. Define audience, features, metrics. For regulated domains, explicitly list compliance requirements. If the prompt is vague, state assumptions rather than asking the user.

#### @ArchitectDB
- **Title**: Principal Systems Architect
- **Sandbox**: `docs/` (write)
- **Rules**: Define tech stack, API contracts, database schemas. Create strict boundaries so frontend and backend don't overlap. Prioritize security, scalability, and domain constraints. Never write implementation code.

#### @BackendEngineer
- **Title**: Backend Developer
- **Sandbox**: `src/backend/` ONLY
- **Rules**: Implement strictly per the architecture document and API contracts. Use domain-appropriate libraries. Create dependency manifests. Never touch frontend files.

#### @FrontendEngineer
- **Title**: UI/UX Frontend Developer
- **Sandbox**: `src/frontend/` ONLY
- **Rules**: Build interfaces per architecture and API contracts. Use mock data if backend isn't ready. Follow modern UI/UX best practices for the domain.

#### @CybersecRedBlue
- **Title**: Application Security Specialist (Red & Blue Team)
- **Sandbox**: Entire `src/` (read + write for patches)
- **Rules**: Act as attacker and defender. Hunt OWASP Top 10, hardcoded secrets, injection flaws, weak crypto. Patch directly and log changes. Domain-specific security checks.

#### @QATester
- **Title**: QA Automation Engineer
- **Sandbox**: `src/` and `tests/` (write), `docs/` (read)
- **Rules**: Write unit and integration tests. Execute via terminal. Run the validation script. Report failures with stack traces and responsible file identification.

#### @TechnicalWriter
- **Title**: Technical Documentation Specialist
- **Sandbox**: Project root (write for README, .env.example, DEPLOYMENT.md)
- **Rules**: Document what was actually built, not what was planned. Ensure setup instructions are complete and accurate.

### Extended Agents (Deployed When Task Requires)

#### @DataEngineer
- **When**: Projects requiring ETL/ELT pipelines, data ingestion, streaming
- **Sandbox**: `src/data/` or `src/pipeline/`
- **Examples**: Astronomy (FITS ingestion), Finance (market data feeds), IoT (telemetry)

#### @ComplianceAuditor
- **When**: Regulated industries (finance, healthcare, defense, government)
- **Sandbox**: `docs/` (write), entire project (read)
- **Role**: Validates that the implementation meets regulatory requirements identified in Phase 1

#### @JointProgramManager
- **When**: Multi-company collaboration projects
- **Sandbox**: `docs/shared/` (write), all company sandboxes (read)
- **Role**: Coordinates cross-company integration, defines shared specs, resolves conflicts

#### @DevOpsEngineer
- **When**: Projects requiring infrastructure-as-code, CI/CD, containerization
- **Sandbox**: `infra/`, `ci/`, project root for config files
- **Role**: Dockerfiles, CI/CD pipelines, deployment scripts

#### @MLEngineer
- **When**: Projects with machine learning components
- **Sandbox**: `src/ml/` or `src/models/`
- **Role**: Model training, inference pipelines, feature engineering

---

## 6. Domain-Adaptive Intelligence

CompanyOS detects the project's industry from the prompt and injects domain-specific knowledge into every agent. This ensures agents reason with the right constraints, standards, and best practices.

### Supported Domains

| Domain | Key Constraints | Example Prompt |
|--------|----------------|----------------|
| **Tech / SaaS** | OWASP, cloud-native, horizontal scaling | "Build a project management SaaS" |
| **Finance / Fintech** | PCI-DSS, SOX audit trails, decimal arithmetic, encryption | "Build a crypto trading platform" |
| **Astronomy / Space** | FITS format, coordinate transforms, large datasets, reproducibility | "Build a tool to analyze JWST spectral data" |
| **Biotech / Healthcare** | HIPAA, FHIR, PHI protection, FDA 21 CFR Part 11 | "Build a patient data management system" |
| **Defense / Government** | FedRAMP, ITAR, STIG, FIPS 140-2, zero-trust | "Build a classified document routing system" |
| **Energy / Industrial** | IEC 62443, SCADA security, real-time, edge computing | "Build a wind turbine telemetry dashboard" |
| **Education / Research** | FERPA, WCAG accessibility, reproducibility, LTI | "Build an online exam platform" |

### How Domain Detection Works

The orchestrator reads your prompt and matches it against domain profiles stored in `references/domains.md`. If the prompt spans multiple domains (e.g., "satellite data for trading"), it activates multi-company collaboration mode with each domain getting its own company team.

---

## 7. Multi-Company Collaboration

For projects that span multiple domains, CompanyOS simulates a **joint venture** between specialized companies.

### When It Activates

The orchestrator detects multi-company need when:
- The prompt explicitly mentions multiple industries
- The task requires expertise that doesn't naturally coexist (e.g., astrophysics + quantitative finance)
- The system architecture naturally splits into domain-isolated subsystems

### How It Works

```
                    ┌──────────────────────┐
                    │  @JointProgramManager │
                    │  (Coordinator)        │
                    └──────────┬───────────┘
                               │
                    ┌──────────┴───────────┐
                    │   docs/shared/        │
                    │   (Neutral Territory)  │
                    │   - data-contracts.md  │
                    │   - api-boundary.md    │
                    │   - integration-tests  │
                    └──────────┬───────────┘
                               │
               ┌───────────────┼───────────────┐
               ▼                               ▼
    ┌─────────────────────┐        ┌─────────────────────┐
    │   Company A          │        │   Company B          │
    │   (e.g., Space Data) │        │   (e.g., FinTech)    │
    │                      │        │                      │
    │   src/astro-data/    │        │   src/trading/        │
    │   docs/company-a/    │        │   docs/company-b/     │
    │                      │        │                      │
    │   Own SDLC:          │        │   Own SDLC:          │
    │   Phases 1-6         │        │   Phases 1-6         │
    │   Own agent roster   │        │   Own agent roster   │
    │   Own domain profile │        │   Own domain profile │
    └─────────────────────┘        └─────────────────────┘
```

### Example

**Prompt**: "Build a platform that ingests telescope data from observatories and runs quantitative trading strategies based on astronomical event correlations"

**CompanyOS deploys:**
- **Company A (Astronomy/Data)**:
  - `@DataEngineer` — builds FITS data ingestion pipeline in `src/astro-data/`
  - `@BackendEngineer` — builds event detection API
  - Domain profile: Astronomy (astropy, coordinate systems, large datasets)

- **Company B (Fintech/Trading)**:
  - `@BackendEngineer` — builds trading engine in `src/trading/`
  - `@FrontendEngineer` — builds trading dashboard
  - Domain profile: Finance (decimal arithmetic, audit trails, compliance)

- **Shared Layer** (`docs/shared/`):
  - `data-contracts.md` — schema for astronomical events passed to trading engine
  - `api-boundary.md` — REST API between Company A's event API and Company B's trading engine
  - `integration-tests.md` — cross-company test criteria

- **@JointProgramManager** coordinates integration after both companies finish their individual SDLCs.

---

## 8. Force Sizing & Task Classification

Not every task needs the full army. CompanyOS calibrates.

### Task Types

| Type | Description | Agents | Model Weights | Phases |
|------|-------------|--------|---------------|--------|
| **Chore** | CSS fix, rename, formatting, trivial change | 1 | `flash_lite` | Build → Validate |
| **Bug** | Fix a specific defect | 2 | `flash` | Scout → Fix → Validate |
| **Feature** | Add capability to existing codebase | 3-5 | `flash`/`inherit` | Scout → Plan → Build → Test → Docs |
| **Product** | Build from scratch | Full team | `inherit`/`pro` | All 7 phases |
| **Hotfix** | Production is down, fix NOW | 2-3 | `inherit` | Parallel racing agents, fastest wins |
| **Cross-Domain** | Multi-company collaboration | Multiple teams | `pro` for leads | Full SDLC per company + integration |

### Model Weight Guidelines

| Weight | Use For | Trade-off |
|--------|---------|-----------|
| `flash_lite` | Formatting, simple docs, trivial changes | Cheapest, fastest, least capable |
| `flash` | Research, scouting, simple engineering | Fast, good for straightforward tasks |
| `inherit` | Standard engineering, architecture, security | Balanced capability and cost |
| `pro` | Complex architecture, deep security analysis, coordination | Most capable, most expensive |

---

## 9. Cross-OS Support

CompanyOS works on Windows, Linux, and macOS without modification.

### How It Works

At startup, the orchestrator detects the host OS and configures:

| OS | Validation Script | Shell | Path Separator |
|----|------------------|-------|----------------|
| Windows | `scripts/validate.ps1` | PowerShell | `\` |
| Linux | `scripts/validate.sh` | Bash | `/` |
| macOS | `scripts/validate.sh` | Bash/Zsh | `/` |

Both validation scripts have identical logic:
1. Auto-detect the project's tech stack (Node.js, Python, Rust, Go, Java)
2. Run the appropriate linter
3. Run the type checker
4. Build the project
5. Run the test suite
6. Run a dependency security scan (advisory, doesn't fail the gate)
7. Return structured pass/fail results

The OS context is passed to every subagent so they write OS-appropriate commands.

---

## 10. Deterministic Validation Gate

This is the "Code" actor from the Three Actors philosophy. It costs zero tokens, never hallucinates, and enforces quality deterministically.

### What It Checks

| Step | What | Failure Action |
|------|------|---------------|
| 1. Lint | Code style and common errors | Route back to Build agent |
| 2. Type Check | Static type analysis | Route back to Build agent |
| 3. Build | Compilation / bundling | Route back to Build agent |
| 4. Tests | Unit and integration tests | Route back to Build agent |
| 5. Security | Dependency vulnerability scan | Advisory only (logged, doesn't block) |

### Supported Tech Stacks (Auto-Detected)

| Stack | Detected By | Linter | Type Checker | Test Runner |
|-------|------------|--------|-------------|-------------|
| Node.js | `package.json` | ESLint / npm run lint | TypeScript (tsc) | npm test |
| Python | `requirements.txt` / `pyproject.toml` | Ruff / Flake8 | mypy / Pyright | pytest |
| Rust | `Cargo.toml` | Clippy | (built-in) | cargo test |
| Go | `go.mod` | golangci-lint / go vet | (built-in) | go test |
| Java | `pom.xml` / `build.gradle` | (IDE/Checkstyle) | (built-in) | Maven/Gradle test |

---

## 11. File Structure & Installation

### Skill Files

```
C:\Users\Aryan\.gemini\config\skills\company-os\
├── SKILL.md                       # Orchestrator brain (main skill definition)
├── references/
│   └── domains.md                 # Domain knowledge profiles (7 industries)
└── scripts/
    ├── validate.ps1               # Windows validation gate (PowerShell)
    └── validate.sh                # Linux/macOS validation gate (Bash)
```

### How Antigravity Loads It

The skill is installed as a **global Antigravity skill** in the config directory. Antigravity automatically discovers it by reading the `SKILL.md` frontmatter:

```yaml
name: company-os
description: >
  Enterprise Agentic Orchestration System. Takes a single prompt and deploys
  a full autonomous engineering department...
```

When the skill activates, the orchestrator reads `SKILL.md` for its instructions, references `domains.md` for domain knowledge, and points agents to the validation scripts.

### Project Output Structure

When CompanyOS runs on a prompt, it creates this structure in your workspace:

```
your-project/
├── docs/
│   ├── 00-battle-plan.md              # Phase 0: Force deployment plan
│   ├── 01-market-requirements.md      # Phase 1: Requirements & analysis
│   ├── 02-architecture.md             # Phase 2: System design
│   ├── 02-api-contracts.json          # Phase 2: API specifications
│   ├── 02-db-schema.sql               # Phase 2: Database schema
│   ├── 03-security-audit.md           # Phase 4: Security findings & patches
│   ├── 04-test-results.md             # Phase 5: Test results
│   └── shared/                        # (Multi-company only)
│       ├── data-contracts.md
│       ├── api-boundary.md
│       └── integration-tests.md
├── src/
│   ├── backend/                       # Backend agent sandbox
│   ├── frontend/                      # Frontend agent sandbox
│   └── data/                          # Data engineer sandbox (if needed)
├── tests/                             # Test files
├── README.md                          # Phase 6: Documentation
├── .env.example                       # Phase 6: Environment template
└── DEPLOYMENT.md                      # Phase 6: Deployment guide
```

---

## 12. Usage Examples

### Example 1: Full Product (Tech/SaaS)

**Prompt:**
> Build a real-time collaborative code editor with syntax highlighting, live cursors, and GitHub integration.

**What happens:**
- Domain: Tech/SaaS
- Task: Product (full build)
- Force: Full team (7 agents, `inherit` weight)
- Phases: All 7 (0-6)
- Result: Complete codebase with WebSocket backend, React frontend, security audit, tests, docs

### Example 2: Fintech Platform

**Prompt:**
> Build a cryptocurrency portfolio tracker with real-time price feeds, tax reporting, and bank-grade security.

**What happens:**
- Domain: Finance/Fintech
- Task: Product
- Force: Full team + `@ComplianceAuditor` (8 agents)
- Extra constraints: PCI-DSS, decimal arithmetic, audit trails, encryption-at-rest
- Phases: All 7, with extra compliance validation in Phase 4

### Example 3: Cross-Domain Collaboration

**Prompt:**
> Build a platform that ingests telescope data from observatories and runs quantitative trading strategies based on astronomical event correlations.

**What happens:**
- Domain: Astronomy + Finance (multi-domain detected)
- Task: Cross-Domain Product
- Force: Two company teams + `@JointProgramManager`
  - Company A (Astronomy): `@DataEngineer`, `@BackendEngineer`
  - Company B (Fintech): `@BackendEngineer`, `@FrontendEngineer`, `@ComplianceAuditor`
- Shared specs in `docs/shared/`
- Integration testing after both companies complete

### Example 4: Simple Chore

**Prompt:**
> Fix the alignment of the login button on the settings page.

**What happens:**
- Domain: Tech (auto-detected from existing codebase)
- Task: Chore
- Force: 1 agent (`flash_lite`)
- Phases: Build → Validate (skip research, architecture, security, docs)

### Example 5: Production Hotfix

**Prompt:**
> The payment processing endpoint is returning 500 errors in production. Fix it NOW.

**What happens:**
- Domain: Finance/Fintech
- Task: Hotfix (emergency)
- Force: 2-3 parallel agents (`inherit`), racing for the fastest fix
- Phases: Diagnose → Fix → Validate (speed over architectural perfection)

### Example 6: Healthcare System

**Prompt:**
> Build a patient appointment scheduling system with EHR integration via FHIR APIs.

**What happens:**
- Domain: Biotech/Healthcare
- Task: Product
- Force: Full team + `@ComplianceAuditor` for HIPAA
- Extra constraints: HIPAA compliance, FHIR standards, PHI encryption, audit logging, consent management
- Phases: All 7, with HIPAA validation woven into every phase

---

## 13. Artifact Handoff Protocol

Agents never communicate directly. Every handoff goes through a document in `docs/`.

```
Phase 0 → docs/00-battle-plan.md
           │
Phase 1 → docs/01-market-requirements.md
           │
Phase 2 → docs/02-architecture.md
         + docs/02-api-contracts.json
         + docs/02-db-schema.sql
           │
Phase 3 → src/backend/, src/frontend/, src/data/ (code)
           │
Phase 4 → docs/03-security-audit.md (+ patches in src/)
           │
Phase 5 → docs/04-test-results.md (+ test files)
           │
Phase 6 → README.md, .env.example, DEPLOYMENT.md
```

### Hard Rules

1. **No phase starts without its predecessor's artifact.** If `docs/01-market-requirements.md` doesn't exist, Phase 2 halts.
2. **Agents read artifacts, not each other's code.** The frontend engineer reads the API contract, not the backend source.
3. **The orchestrator is the only entity that invokes agents.** Agents never invoke other agents.

---

## 14. Error Recovery & Self-Healing

When tests fail in Phase 5, the system doesn't just report the failure. It self-heals:

1. **QA agent** captures the exact error output, stack trace, and identifies the responsible file
2. **Orchestrator** determines which engineering agent owns that file (backend? frontend? data?)
3. **Orchestrator re-invokes** ONLY that specific agent with the error context
4. **Agent fixes** the issue in its sandbox
5. **QA re-runs** the validation
6. **Loop** until all tests pass (maximum 3 iterations to prevent infinite loops)
7. If still failing after 3 iterations → **halt and report to user** with full error context

---

## 15. Customization & Extension

### Adding New Domains

Edit `references/domains.md` and add a new section following the existing pattern:
```markdown
## Your Domain Name

**Context for agents:**
Description of the domain...

**Key constraints:**
- Constraint 1
- Constraint 2

**Tech stack preferences:**
- Preferred technologies
```

### Adding New Agent Roles

Edit the "Extended Roles" section in `SKILL.md`. Follow the existing pattern:
```markdown
#### @YourNewRole
- **When**: Conditions for deployment
- **Sandbox**: `src/your-dir/`
- **Model**: `inherit`
- **Rules**: What this agent does and doesn't do
```

### Modifying the Validation Gate

Edit `scripts/validate.ps1` (Windows) or `scripts/validate.sh` (Linux/macOS) to add new tech stacks or modify the check sequence.

---

## 16. Troubleshooting

### "The skill doesn't appear in Antigravity"

Ensure the `SKILL.md` file is at: `C:\Users\Aryan\.gemini\config\skills\company-os\SKILL.md`

The YAML frontmatter must have `name` and `description` fields.

### "Agents are writing outside their sandbox"

The sandbox enforcement is instruction-based (via the agent's system prompt), not filesystem-level. If an agent violates its sandbox, it's a prompt adherence issue. Check that the orchestrator is injecting the correct sandbox constraints when invoking the subagent.

### "The validation script fails to detect my tech stack"

The scripts look for specific files (`package.json`, `requirements.txt`, `Cargo.toml`, etc.). If your project uses a different convention, edit the `detect_stack` function in the validation script.

### "Multi-company mode doesn't activate"

Multi-company mode activates when the orchestrator detects multiple distinct domains in the prompt. If your prompt is ambiguous, be more explicit: "This project requires expertise in [domain A] AND [domain B]."

---

## Credits

- **Philosophy**: IndyDevDan's Agentic Engineering framework ([source video](https://youtu.be/VQy50fuxI34))
- **Implementation**: Built as a native Google Antigravity skill
- **Original concept**: Adapted from the Enterprise Agentic Orchestration Guide and conversation history

---

*CompanyOS v1.0 — Enterprise Agentic Orchestration System*
*Built for Antigravity. Works everywhere.*
