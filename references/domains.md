# Domain Knowledge Profiles

When the CompanyOS orchestrator detects a project's industry domain, it injects
the matching profile below into every subagent's context. This ensures agents
reason with domain-appropriate constraints, standards, and best practices.

---

## Tech / SaaS

**Context for agents:**
Standard web/mobile/cloud software development. No extraordinary regulatory
constraints beyond standard security practices.

**Key constraints:**
- Follow OWASP Top 10 for web security
- Design for horizontal scalability (stateless services, load balancing)
- Use cloud-native patterns (containers, managed databases, CDN)
- CI/CD from day one
- REST or GraphQL APIs with proper versioning
- 99.9% uptime SLA target for production services

**Tech stack preferences:**
- Backend: Node.js/Express, Python/FastAPI, Go, Rust — whatever fits the use case
- Frontend: React, Vue, Svelte — modern component-based frameworks
- Database: PostgreSQL (relational), MongoDB (document), Redis (cache)
- Infrastructure: Docker, Kubernetes, cloud-managed services

---

## Finance / Fintech

**Context for agents:**
Financial software operates under strict regulatory and auditability
requirements. Every transaction must be traceable. Data integrity is
non-negotiable. Rounding errors in currency arithmetic are bugs.

**Key constraints:**
- **PCI-DSS** compliance for any payment card data handling
- **SOX (Sarbanes-Oxley)** audit trails for financial reporting systems
- **Encryption-at-rest** and **encryption-in-transit** for ALL financial data
- Use **decimal/fixed-point arithmetic** — NEVER floating-point for money
- Idempotent transaction processing (exactly-once semantics)
- Comprehensive audit logging (who changed what, when, from where)
- Rate limiting and fraud detection patterns
- Regulatory reporting data retention (typically 7+ years)
- Multi-factor authentication for all administrative interfaces
- Disaster recovery with RPO < 1 hour, RTO < 4 hours

**Tech stack preferences:**
- Languages with strong type systems (Java, Kotlin, Rust, Go, TypeScript)
- PostgreSQL with strict ACID transactions
- Message queues for async processing (Kafka, RabbitMQ)
- Time-series databases for market data (TimescaleDB, InfluxDB)

---

## Astronomy / Space Science

**Context for agents:**
Astronomical software deals with massive datasets, specialized file formats,
coordinate system transformations, and high-performance computing. Users are
often researchers who need reproducibility and scriptability.

**Key constraints:**
- **FITS file format** support (Flexible Image Transport System)
- Coordinate system handling (RA/Dec, Alt/Az, Galactic, ecliptic)
- WCS (World Coordinate System) transformations
- Large dataset pipelines (terabytes to petabytes)
- Numerical precision matters — use double precision or higher
- Reproducibility: random seeds, version-pinned dependencies, data provenance
- Integration with observatory APIs and data archives (MAST, ESO, IRSA)
- Visualization: sky maps, spectra, light curves, image mosaics

**Tech stack preferences:**
- Python (astropy, numpy, scipy, matplotlib, healpy)
- Jupyter notebooks for exploratory analysis
- HDF5 or Parquet for large columnar datasets
- Dask or Apache Spark for distributed processing
- PostgreSQL with Q3C or PostGIS for spatial queries

---

## Biotech / Healthcare

**Context for agents:**
Healthcare software must protect patient data above all else. Regulatory
compliance is legally mandated and failure carries severe penalties.

**Key constraints:**
- **HIPAA** compliance: PHI (Protected Health Information) must be encrypted,
  access-controlled, and audit-logged at every layer
- **HL7 / FHIR** standards for health data interoperability
- **FDA 21 CFR Part 11** for electronic records and signatures (if applicable)
- De-identification procedures for research datasets
- Role-based access control with principle of least privilege
- Consent management for patient data usage
- Data retention policies per jurisdiction
- Backup and disaster recovery with zero data loss tolerance
- Accessibility (WCAG 2.1 AA minimum) for patient-facing interfaces

**Tech stack preferences:**
- FHIR-compliant APIs (HAPI FHIR, Microsoft FHIR Server)
- PostgreSQL with row-level security
- Strong encryption libraries (libsodium, BoringSSL)
- Kubernetes with network policies for microsegmentation
- React or Angular for complex clinical interfaces

---

## Defense / Government

**Context for agents:**
Government and defense software has the strictest security and compliance
requirements. Assume adversarial threat environments and disconnected
operation scenarios.

**Key constraints:**
- **FedRAMP** authorization for cloud deployments
- **ITAR** compliance for defense-related technical data
- **STIG hardening** for all operating systems and middleware
- **NIST 800-53** security controls framework
- Air-gapped deployment capability (no dependency on external services at runtime)
- **FIPS 140-2/3** validated cryptographic modules
- Data classification labeling (Unclassified, CUI, Secret, Top Secret)
- Supply chain security (SBOM generation, dependency auditing)
- Multi-level security (MLS) data handling
- Zero-trust architecture principles

**Tech stack preferences:**
- Languages approved by agency standards (often Java, C/C++, Python, Rust)
- Hardened Linux distributions (RHEL, Rocky Linux with DISA STIG)
- On-premise or GovCloud deployments
- PKI-based authentication (CAC/PIV cards)
- Container hardening (Iron Bank approved base images)

---

## Energy / Industrial / IoT

**Context for agents:**
Industrial software interfaces with physical infrastructure. Reliability,
real-time performance, and safety are paramount. Downtime can mean physical
danger.

**Key constraints:**
- **IEC 62443** for industrial cybersecurity
- **SCADA/ICS** security awareness — never expose control systems directly
- Real-time data processing with strict latency requirements
- Protocol support: MQTT, OPC-UA, Modbus, BACnet as needed
- Edge computing capability (may run on constrained hardware)
- Offline-first operation (network may be unreliable)
- Safety-critical system awareness (fail-safe defaults)
- Time-series data at scale (sensor telemetry)
- Environmental monitoring and alerting

**Tech stack preferences:**
- Rust or C/C++ for edge/embedded components
- Python for data analysis and ML layers
- InfluxDB or TimescaleDB for time-series
- MQTT broker (Mosquitto, HiveMQ)
- Grafana for operational dashboards

---

## Education / Research

**Context for agents:**
Educational and research software prioritizes accessibility, reproducibility,
and open standards. Users range from students to professors with varying
technical skill levels.

**Key constraints:**
- **FERPA** compliance for student data (in US educational contexts)
- **WCAG 2.1 AA** accessibility minimum
- Open data formats and standards where possible
- Reproducibility: all analysis must be repeatable from source data
- Citation and provenance tracking
- Multi-tenant architecture (multiple institutions/classes)
- LTI (Learning Tools Interoperability) for LMS integration
- Export capabilities (CSV, JSON, PDF for reports)

**Tech stack preferences:**
- Python (Jupyter, pandas, scikit-learn for research tools)
- React or Vue for web interfaces
- PostgreSQL for structured data
- S3-compatible storage for large datasets
- OAuth2/SAML for institutional SSO

---

## Mixed / Cross-Domain

When a project spans multiple domains, the orchestrator activates
**Multi-Company Collaboration** mode:

1. Each domain gets its own "company" team with the appropriate domain profile
2. A `@JointProgramManager` coordinates the integration boundaries
3. Shared specifications live in `docs/shared/` — neutral territory
4. Each company's agents receive only their own domain profile

**Example combinations:**
- Astronomy + Finance: Space data analytics for trading signals
- Healthcare + AI/Tech: Clinical decision support systems
- Defense + IoT: Military sensor network platforms
- Energy + Finance: Carbon credit trading platforms
- Biotech + Education: Research collaboration platforms
