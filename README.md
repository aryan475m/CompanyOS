# CompanyOS

CompanyOS is an **Antigravity skill** that transforms a single natural-language prompt into a fully autonomous software development operation. It deploys a team of specialized AI agents — each with strict role boundaries, isolated sandboxes, and artifact handoff protocols — that collectively execute a complete Software Development Life Cycle (SDLC).

## Features
- **Industry-Agnostic:** Automatically adapts team composition for tech, finance, astronomy, biotech, defense, or any domain based on the prompt.
- **Dynamic Force Sizing:** Deploys an appropriately sized team based on task complexity (e.g. 1 lightweight agent for a CSS fix, full battalion for a SaaS app).
- **Multi-Company Collaboration:** Spins up isolated "company" teams that collaborate through shared spec documents for cross-domain projects.
- **Cross-Platform Validation:** Works seamlessly on Windows, Linux, and macOS with auto-detected deterministic validation scripts.
- **Strict Directory Sandboxing:** Prevents code interference by confining agents to their respective sandboxes and forcing artifact handoffs.

## Installation

1. Copy the contents of this repository to your Antigravity skills directory:
   - Location: `~/.gemini/config/skills/company-os/`
2. Define a global rule in your `~/.gemini/GEMINI.md` to auto-activate the skill whenever a product-level prompt is received. (e.g., when the user says "company-os", "deploy the team", "build this like a company", "enterprise factory", etc.)

## Included Components
- **`SKILL.md`**: The orchestrator brain that determines phase execution, agent constitutions, multi-company collaboration logic, and OS detection.
- **`references/domains.md`**: Domain knowledge profiles that get dynamically injected into agents.
- **`scripts/validate.ps1` & `scripts/validate.sh`**: Deterministic validation gates tailored for your OS.
- **`CompanyOS_Documentation.md`**: Comprehensive documentation for the system architecture, usage examples, and troubleshooting.

## How It Works
When activated, CompanyOS analyzes the prompt to detect the domain and classify the task complexity, selecting the appropriate force size and phase routing. Agents interact via strict handoff documents (`docs/`) to construct frontend, backend, test environments, documentation, and perform security hardening. 

*Built for Antigravity. Works everywhere.*
