# AI Infrastructure Sizing Platform
## Master Implementation Prompt Pack v1.0

**Purpose:** A single reusable prompt file for implementing every controlled feature and user-story area of the AI Infrastructure Sizing and Commercial Planning Platform without drifting from the approved product idea.

**Use rule:** Run prompts in sequence. Do not skip a checkpoint. Each prompt must operate against the actual repository and the latest approved requirement, formula, catalog, HLD, LLD and verification baselines.

---

# 1. Authoritative Baseline

The implementation must remain aligned with these controlled artifacts:

1. `AIS-MBSRS-001` Master Business and System Requirements Specification
2. `AIS-DDDMS-001` Input/Output Data Dictionary and Decision Matrix Specification
3. `AIS-FPCS-001` Formula, Policy and Calculation Specification
4. `AIS-CEDS-001` Catalog and Evidence Data Specification
5. `AIS-UXSWRS-001` User Experience, Screen, Workflow and Reporting Specification
6. `AIS-PHLD-001` Production High-Level Design
7. `AIS-PLLD-001` Production Low-Level Design
8. `AIS-RTMVP-001` Requirements Traceability Matrix and Verification Plan
9. Source Requirements Register with 124 stable requirement IDs

If the repository behavior conflicts with the controlled baseline, stop and report the conflict. Do not silently choose the repository behavior.

---

# 2. Non-Negotiable Product Guardrails

- Do not invent formulas, thresholds, benchmark values, model capabilities, compatibility, server configurations, cloud SKUs, prices, quotations or evidence.
- Use only active, versioned and traceable catalog, evidence, policy and formula records.
- Missing data is not zero. Use `Review Required`, `Missing Price`, `Quote Required`, or the applicable controlled state.
- No random model, precision, runtime, GPU, server, cloud service, cluster, quantity, BOM line or price selection.
- Apply hard eligibility gates before optimization.
- Always maintain both `Performance-Optimized` and `Price-Optimized` outcomes.
- Keep Development and Production calculations separate.
- Apply HA, maintenance and DR quantities exactly once at their owned layer.
- Aggregate compatible demand before integer rounding.
- Preserve full input, formula, policy, catalog, evidence, benchmark, output and audit traceability.
- Model override must create a new version and recalculate every affected downstream result.
- The browser must not own authoritative formulas.
- Generative AI must not be used in the authoritative calculation or recommendation path.
- Approval workflows must not block deterministic calculation. Approval controls release activation and readiness.
- Do not replace precise behavior with placeholders, mock logic or TODOs unless the prompt is explicitly an approved scaffold step.

---

# 3. Required Industry Frameworks and Design Strategies

Apply the following consistently:

- Domain-Driven Design with explicit bounded contexts and aggregate ownership.
- Modular monolith first, with independently scalable calculation, import, report and scheduler workers.
- Clean Architecture and dependency inversion at domain/platform boundaries.
- SOLID principles, typed contracts, explicit state machines and deterministic pure functions.
- API-first design using a pinned OpenAPI 3.2.x patch and JSON Schema.
- Secure-by-design and threat-informed development using NIST SSDF and OWASP ASVS 5.0.0.
- WCAG 2.2 AA, semantic HTML, keyboard operation, visible focus, accessible names, error associations and non-color status cues.
- Event-driven asynchronous processing using durable queues, idempotency, outbox/inbox and dead-letter handling.
- Immutable snapshots, append-only calculation outputs, optimistic concurrency for drafts and content hashes for artifacts.
- Twelve-factor configuration principles where applicable, but keep formulas, policies and catalogs in governed data releases rather than environment variables.
- Observability by design using structured logs, metrics, traces, correlation IDs and business-stage telemetry.
- Test pyramid plus property-based, contract, integration, golden-scenario, sensitivity, security, accessibility, performance, resilience and recovery testing.
- Progressive disclosure and business-first UX, with Guided, Expert, Governance and Audit modes.

---

# 4. Universal Prompt Execution Contract

Every feature prompt below inherits this contract.

## 4.1 Before coding

1. Read the referenced requirement IDs and controlled documents.
2. Inspect the current repository structure, existing modules, schemas, migrations, APIs, tests and conventions.
3. Produce a short implementation plan containing:
   - requirement IDs covered;
   - design components affected;
   - files to create or modify;
   - data migrations;
   - APIs/events/jobs;
   - security and accessibility controls;
   - test plan;
   - risks, assumptions and unresolved decisions.
4. Identify conflicts or missing governed inputs. Do not assume values.
5. Reuse existing patterns only when they comply with the controlled baseline.

## 4.2 During coding

- Implement production-quality code, not pseudocode.
- Keep domain logic independent from UI and infrastructure adapters.
- Add server-side validation even when client-side validation exists.
- Use precise decimal and canonical-unit types for calculations.
- Add correlation, tenant and run context to applicable logs and jobs without logging sensitive values.
- Make commands idempotent where required.
- Make mutable APIs concurrency-safe with ETag/version checks.
- Add database constraints and indexes matching invariants.
- Add migration and rollback/roll-forward notes.
- Add accessible loading, empty, error and success states.
- Add trace data and audit events for governed actions.

## 4.3 Required deliverables from every prompt

1. Requirement-to-code mapping.
2. File change summary.
3. Database/API/event changes.
4. Security and tenant-isolation review.
5. Accessibility review where UI is affected.
6. Unit, property, contract and integration tests as applicable.
7. Golden/sensitivity/reconciliation tests where decision logic is affected.
8. Commands executed and results.
9. Remaining risks, open decisions and blocked items.
10. Checkpoint report using the format below.

## 4.4 Universal checkpoint

Do not move to the next prompt until all applicable items are complete.

- [ ] Referenced requirement IDs are implemented or explicitly blocked.
- [ ] No unsupported formula, policy, benchmark, compatibility or price was introduced.
- [ ] Domain boundaries and dependency rules are preserved.
- [ ] Tenant isolation and authorization are enforced at API, service and data layers.
- [ ] Validation includes field, cross-field and semantic behavior.
- [ ] Error, loading, empty and retry states are implemented.
- [ ] Accessibility requirements are tested for changed UI.
- [ ] Idempotency, concurrency and audit behavior are tested where applicable.
- [ ] Traceability includes Formula IDs, policy/catalog/evidence release IDs and run IDs where applicable.
- [ ] Unit and integration tests pass.
- [ ] Golden, sensitivity and reconciliation tests pass where applicable.
- [ ] No critical/high security findings remain.
- [ ] Documentation and ADRs are updated.
- [ ] The feature is mapped to verification cases and release gates.

**Checkpoint output:** `PASS`, `PASS WITH OPEN ACTIONS`, or `BLOCKED`. Never report `PASS` if mandatory tests or evidence are missing.

---

# 5. Master Orchestration Prompt

Use this prompt at the start of a new implementation session:

```text
Act as the principal product architect, staff software engineer, security engineer, UX accessibility lead, data architect, QA architect and FinOps-aware AI infrastructure architect for the AI Infrastructure Sizing Platform.

Use the Master Implementation Prompt Pack and the controlled artifacts listed in its Authoritative Baseline. Inspect the real repository before making changes.

Current target prompt: [PROMPT_ID and PROMPT_NAME]
Current requirement IDs: [REQUIREMENT_IDS]
Current repository/build: [BRANCH_OR_COMMIT]

Rules:
1. Do not deviate from the controlled product idea.
2. Do not invent deterministic logic or governed data.
3. If a required policy/catalog/evidence value is missing, implement the controlled missing-data behavior and report the owner action.
4. Follow Domain-Driven Design, Clean Architecture, API-first design, secure-by-design, WCAG 2.2 AA, immutable snapshots, idempotent asynchronous processing and test-driven verification.
5. Implement only the target prompt scope plus necessary shared foundations. Do not redesign unrelated features.
6. Preserve backward compatibility unless the controlled baseline requires a versioned breaking change.
7. Before coding, provide the implementation plan and conflict report.
8. After coding, execute the required tests and produce the checkpoint report.

Deliver production-quality implementation and objective evidence. Stop at the checkpoint if any mandatory condition is not satisfied.
```

---

# 6. Feature Prompt Catalogue

## P00 - Repository and Architecture Foundation

### Objective

Create the production repository, module boundaries, executable hosts, shared contracts, configuration hierarchy, dependency rules, and ADR placeholders defined by AIS-PHLD-001 and AIS-PLLD-001.

### Controlled references

`ADR-001 to ADR-009; ADR-LLD-001 to ADR-LLD-012`

### Required implementation scope

apps/web, apps/api, calculation/import/report/scheduler workers, domain modules, platform adapters, contracts, tests.

### Feature-specific instructions

```text
Implement Repository and Architecture Foundation for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: ADR-001 to ADR-009; ADR-LLD-001 to ADR-LLD-012.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P01 - Design System and Application Shell

### Objective

Build the responsive application shell, global navigation, project context header, Guided/Expert/Governance/Audit mode switching, status indicators, error boundaries, and accessible component primitives.

### Controlled references

`SCR-001 to SCR-034; AIS-UXSWRS-001 sections 1-4 and 11`

### Required implementation scope

design tokens, layout primitives, navigation, breadcrumbs, notifications, dialogs, tables, forms, empty/loading/error states.

### Feature-specific instructions

```text
Implement Design System and Application Shell for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-001 to SCR-034; AIS-UXSWRS-001 sections 1-4 and 11.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P02 - Identity, Tenancy and Authorization

### Objective

Implement enterprise identity integration, organization membership, role assignments, resource authorization, tenant context propagation, database row-level isolation, and append-only security audit events.

### Controlled references

`NFR-SEC-001; LLD sections 4.3 and 10`

### Required implementation scope

authentication middleware, authorization policies, membership APIs, tenant repositories, RLS migrations, cross-tenant tests.

### Feature-specific instructions

```text
Implement Identity, Tenancy and Authorization for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: NFR-SEC-001; LLD sections 4.3 and 10.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P03 - Home, Projects and Project Creation

### Objective

Implement project listing, search, filters, create, open, clone, recent items, ownership, project status and organization-scoped access.

### Controlled references

`SCR-001, SCR-002, SCR-004; FR-PRJ-001 to FR-PRJ-003`

### Required implementation scope

project APIs, pages, forms, repository, optimistic concurrency, audit events, tests.

### Feature-specific instructions

```text
Implement Home, Projects and Project Creation for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-001, SCR-002, SCR-004; FR-PRJ-001 to FR-PRJ-003.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P04 - Scenario Versioning and Workspace

### Objective

Implement scenario creation, immutable version lineage, editable drafts, sealing, cloning, supersession, context header and version comparison entry points.

### Controlled references

`SCR-004, SCR-005, SCR-024; HLD snapshot model; LLD section 5`

### Required implementation scope

scenario/version APIs, state machine, ETags, workspace store, comparison metadata, audit.

### Feature-specific instructions

```text
Implement Scenario Versioning and Workspace for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-004, SCR-005, SCR-024; HLD snapshot model; LLD section 5.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P05 - Guided Project Inputs

### Objective

Implement business-first project inputs for industry, planning period, deployment preference, provider and region, availability, DR, security, residency, budget, workload growth and data growth with progressive disclosure.

### Controlled references

`SCR-005; FR-INP-001 to FR-INP-025`

### Required implementation scope

field metadata renderer, governed dropdowns, conditional visibility, help panels, validation, save draft.

### Feature-specific instructions

```text
Implement Guided Project Inputs for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-005; FR-INP-001 to FR-INP-025.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P06 - Application and Workload Builder

### Objective

Implement repeatable applications and multiple use cases, industry-filtered use-case selection, derived workload type, demand-unit behavior, use-case distribution, environment scope and archive/duplicate/delete-draft actions.

### Controlled references

`SCR-006; AIS-DDDMS-001; AIS-CEDS-001 use-case catalog`

### Required implementation scope

application/workload components, APIs, ordering, distribution validation, catalog lookups, tests.

### Feature-specific instructions

```text
Implement Application and Workload Builder for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-006; AIS-DDDMS-001; AIS-CEDS-001 use-case catalog.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P07 - Request and Response Profile

### Objective

Implement Typical Request, Supporting Context, Conversation History, Expected Answer Type, Tool or Agent Usage, Model Calls per Transaction, Prompt Caching Permitted, Simple/Medium/Complex mix, language coverage and file types.

### Controlled references

`SCR-007; request/response field contract`

### Required implementation scope

governed controls, numeric validation, complexity total 100%, impact preview, source/Formula ID help.

### Feature-specific instructions

```text
Implement Request and Response Profile for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-007; request/response field contract.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P08 - Development and Training Profiles

### Objective

Implement independent Development inputs and training/fine-tuning inputs, including developers, experiments, model concurrency, method, tokens, epochs, sequence, optimizer profile, deadline and storage/checkpoint needs.

### Controlled references

`SCR-008, SCR-009; AIS-FPCS-001 training formulas`

### Required implementation scope

conditional forms, typed values, unit handling, environment separation, tests.

### Feature-specific instructions

```text
Implement Development and Training Profiles for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-008, SCR-009; AIS-FPCS-001 training formulas.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P09 - Validation Framework and Validation Summary

### Objective

Implement syntax, cross-field, semantic, mapping, evidence and readiness validation without using approval as a calculation blocker.

### Controlled references

`SCR-010; STG-02; LLD section 9`

### Required implementation scope

rule registry, JSON Schema validation, validation API, issue model, field links, error/warning/review-required behavior.

### Feature-specific instructions

```text
Implement Validation Framework and Validation Summary for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-010; STG-02; LLD section 9.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P10 - Calculation Orchestration and Immutable Snapshots

### Objective

Implement run submission, idempotency, snapshot resolution, run/stage states, durable jobs, retries, cancellation at safe boundaries, progress reporting and immutable result linkage.

### Controlled references

`SCR-011; STG-01 to STG-12; HLD section 7; LLD sections 5, 7 and 8`

### Required implementation scope

orchestrator, queue messages, outbox/inbox, stage repository, status API, tests.

### Feature-specific instructions

```text
Implement Calculation Orchestration and Immutable Snapshots for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-011; STG-01 to STG-12; HLD section 7; LLD sections 5, 7 and 8.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P11 - Workload, Token and Context Engine

### Objective

Implement governed workload-demand conversion, token components, complexity weighted averages, P95 handling, model calls, caching adjustment, context requirement and language/modality impacts.

### Controlled references

`STG-03; AIS-FPCS-001 token/demand formulas; SCR-015`

### Required implementation scope

pure formula functions, unit types, trace output, invariant tests, sensitivity tests.

### Feature-specific instructions

```text
Implement Workload, Token and Context Engine for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: STG-03; AIS-FPCS-001 token/demand formulas; SCR-015.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P12 - Model Eligibility and Dual-Objective Selection

### Objective

Implement hard model gates, quality evidence evaluation, eligible/rejected candidates, Performance-Optimized and Price-Optimized ranking, deterministic tie-breaks and explicit no-candidate behavior.

### Controlled references

`SCR-012; FR-MOD-001 to FR-MOD-024; STG-04`

### Required implementation scope

candidate pipeline, gate results, objective scores, deterministic sorting, explanations, tests.

### Feature-specific instructions

```text
Implement Model Eligibility and Dual-Objective Selection for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-012; FR-MOD-001 to FR-MOD-024; STG-04.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P13 - Model Validation Checkpoint

### Objective

Implement the mandatory second model-validation checkpoint that seals the two objective winners before downstream precision, memory and infrastructure decisions.

### Controlled references

`SCR-013; STG-05`

### Required implementation scope

checkpoint rules, baseline table, pass/fail/unknown results, evidence links, blocking behavior, tests.

### Feature-specific instructions

```text
Implement Model Validation Checkpoint for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-013; STG-05.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P14 - Precision and Runtime Selection

### Objective

Implement model-compatible precision and runtime gates, quality thresholds, hardware support, deployment/lifecycle constraints and deterministic selection.

### Controlled references

`SCR-014; STG-06; Runtime and Precision Catalog`

### Required implementation scope

compatibility evaluator, matrix UI, quality evidence, candidate trace, tests.

### Feature-specific instructions

```text
Implement Precision and Runtime Selection for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-014; STG-06; Runtime and Precision Catalog.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P15 - Memory Sizing

### Objective

Implement model weights, quantization metadata, KV cache using KV heads, runtime workspace, activation/buffer/fragmentation and reserve calculations, GPU fit and topology constraints.

### Controlled references

`SCR-016; STG-07; AIS-FPCS-001 memory formulas`

### Required implementation scope

formula package, typed units, breakdown API/UI, invariants, boundary and golden tests.

### Feature-specific instructions

```text
Implement Memory Sizing for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-016; STG-07; AIS-FPCS-001 memory formulas.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P16 - Inference Capacity and Service-Level Constraints

### Objective

Implement input TPS, output TPS, RPS, concurrency, TTFT, TPOT, prefill/decode constraints, utilization, benchmark matching, replicas and binding constraint selection.

### Controlled references

`SCR-017; STG-07; benchmark catalog`

### Required implementation scope

exact/near/prohibited match evaluation, capacity formulas, binders, explanations, tests.

### Feature-specific instructions

```text
Implement Inference Capacity and Service-Level Constraints for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-017; STG-07; benchmark catalog.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P17 - Training Capacity and Schedule

### Objective

Implement training compute, memory, time-to-train, deadline feasibility, checkpoint storage and environment-specific resource quantities using approved method-specific formulas.

### Controlled references

`SCR-017; training formula family`

### Required implementation scope

training calculator, feasibility gates, benchmark/profile evidence, trace and tests.

### Feature-specific instructions

```text
Implement Training Capacity and Schedule for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-017; training formula family.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P18 - GPU, Server and Cloud Candidate Selection

### Objective

Implement exact deployable candidate generation for GPUs, complete server configurations and provider-specific cloud SKUs with compatibility, availability, region, lifecycle and cost gates.

### Controlled references

`SCR-018; STG-08; GPU/server/cloud catalogs`

### Required implementation scope

candidate adapters, gate matrix, exact configuration references, rejected reasons, objective ranking.

### Feature-specific instructions

```text
Implement GPU, Server and Cloud Candidate Selection for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-018; STG-08; GPU/server/cloud catalogs.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P19 - Cluster Consolidation and Allocation

### Objective

Implement compatibility keys, schedule overlap, allocation mode, aggregate-before-rounding, workload allocation and independent Development and Production pools without double-counting shared components.

### Controlled references

`SCR-019; STG-09; FR-CLS-*`

### Required implementation scope

cluster/pool/allocation data model, deterministic grouping, rounding, reconciliation, tests.

### Feature-specific instructions

```text
Implement Cluster Consolidation and Allocation for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-019; STG-09; FR-CLS-*.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P20 - High Availability, Maintenance and Disaster Recovery

### Objective

Implement active, failure reserve, maintenance reserve and DR quantities exactly once at the owned layer, using governed availability, RTO/RPO and DR policies.

### Controlled references

`SCR-020; STG-10; FR-HA-001; FR-DR-001`

### Required implementation scope

resilience allocator, purpose-separated quantities, warm/cold/active policies, UI breakdown, tests.

### Feature-specific instructions

```text
Implement High Availability, Maintenance and Disaster Recovery for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-020; STG-10; FR-HA-001; FR-DR-001.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P21 - Detailed BOM Generation

### Objective

Generate complete on-premises and cloud BOM lines by environment, objective, cluster, pool, category and quantity purpose, with shared components consolidated and every line traceable.

### Controlled references

`SCR-022; STG-11; FR-BOM-*`

### Required implementation scope

BOM service, component expansion, quantity reconciliation, price/evidence states, filtering/export read model.

### Feature-specific instructions

```text
Implement Detailed BOM Generation for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-022; STG-11; FR-BOM-*.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P22 - Financial Calculation and TCO

### Objective

Implement CAPEX, recurring OPEX, cloud run rate, planning-period TCO, workload and data growth, currency and FX handling, commitment models, and explicit scope/exclusions.

### Controlled references

`SCR-023; STG-11; FR-FIN-*`

### Required implementation scope

financial periods, decimal precision, missing-price state, totals/reconciliation, sensitivity, tests.

### Feature-specific instructions

```text
Implement Financial Calculation and TCO for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-023; STG-11; FR-FIN-*.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P23 - Readiness and Executive Recommendation

### Objective

Implement ordered Planning Estimate, Architecture Ready, Quote Required and Procurement Ready gates; four Development/Production and Performance/Price options; recommendation, confidence, limitations and next actions.

### Controlled references

`SCR-021, SCR-023; STG-12`

### Required implementation scope

readiness service, executive dashboard, gate summary, evidence/confidence display, tests.

### Feature-specific instructions

```text
Implement Readiness and Executive Recommendation for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-021, SCR-023; STG-12.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P24 - Model Override and Recalculation

### Objective

Implement controlled eligible-model override, mandatory reason, new scenario/run version, full recalculation, before/after comparison and immutable audit.

### Controlled references

`SCR-025; FR-MOD-024`

### Required implementation scope

override command/API/dialog, eligibility enforcement, run creation, impact comparison, audit tests.

### Feature-specific instructions

```text
Implement Model Override and Recalculation for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-025; FR-MOD-024.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P25 - Scenario Comparison

### Objective

Compare two to four scenario versions or objective paths across inputs, derived values, release versions, models, infrastructure, BOM, financials and readiness.

### Controlled references

`SCR-024; RPT-005`

### Required implementation scope

alignment service, diff categories, materiality highlighting, trace links, export.

### Feature-specific instructions

```text
Implement Scenario Comparison for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-024; RPT-005.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P26 - Catalog Browser and Record Editor

### Objective

Implement versioned catalog search, filters, draft creation/editing, field schemas, evidence mappings, lifecycle, confidence, limitations and tenant/global scope.

### Controlled references

`SCR-028, SCR-029; FR-CAT-*; AIS-CEDS-001`

### Required implementation scope

catalog APIs/UI, schemas, ETags, claim mapping, evidence viewer, validation.

### Feature-specific instructions

```text
Implement Catalog Browser and Record Editor for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-028, SCR-029; FR-CAT-*; AIS-CEDS-001.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P27 - Catalog Import, Conflict Resolution and Approval

### Objective

Implement quarantine, scanning, parsing, staging, key/relationship checks, duplicate/conflict detection, release candidate, independent approval and activation.

### Controlled references

`SCR-030, SCR-031; AIS-CEDS-001 sections 14-17`

### Required implementation scope

import worker, staging tables, import report, approval workflow, separation of duties, audit.

### Feature-specific instructions

```text
Implement Catalog Import, Conflict Resolution and Approval for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-030, SCR-031; AIS-CEDS-001 sections 14-17.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P28 - Evidence, Price and Quote Management

### Objective

Implement immutable evidence snapshots, hashes, claim coverage, freshness/expiry, classification, source quality, price records, quote validity, missing-price state and restricted supplier terms.

### Controlled references

`SCR-027; evidence and price catalogs`

### Required implementation scope

object storage, metadata APIs/UI, expiry scheduler, access controls, readiness integration.

### Feature-specific instructions

```text
Implement Evidence, Price and Quote Management for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-027; evidence and price catalogs.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P29 - Trace Explorer and Audit History

### Objective

Implement end-to-end input-to-formula-to-catalog-to-evidence-to-output lineage, run reconstruction, immutable before/after events and authorized search/export.

### Controlled references

`SCR-026, SCR-033; FR-TRC-001`

### Required implementation scope

trace read model, graph/tree UI, audit API, filters, artifact links, integrity tests.

### Feature-specific instructions

```text
Implement Trace Explorer and Audit History for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-026, SCR-033; FR-TRC-001.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P30 - Reports and Controlled Exports

### Objective

Implement all ten report types with immutable run references, release IDs, classifications, hashes, watermarks/readiness labels, and PDF/DOCX/XLSX/CSV/JSON outputs.

### Controlled references

`SCR-032; RPT-001 to RPT-010`

### Required implementation scope

report jobs, format renderers, templates, access control, reconciliation, accessibility.

### Feature-specific instructions

```text
Implement Reports and Controlled Exports for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-032; RPT-001 to RPT-010.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P31 - Administration and Notifications

### Objective

Implement organization settings, memberships, roles, retention, integrations and notifications for run completion, approvals, evidence expiry and readiness changes.

### Controlled references

`SCR-034; notification and administration modules`

### Required implementation scope

admin UI/APIs, scheduler, provider adapters, preferences, audit.

### Feature-specific instructions

```text
Implement Administration and Notifications for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: SCR-034; notification and administration modules.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P32 - Observability, Reliability and Recovery

### Objective

Implement structured logs, traces, metrics, health checks, dashboards, alerts, runbooks, backup/restore, failover, DLQ replay and unfinished-job reconstruction.

### Controlled references

`NFR-OPS-001; HLD sections 12-14; LLD sections 12-14`

### Required implementation scope

OpenTelemetry instrumentation, SLOs, alerts, recovery automation, operational tests.

### Feature-specific instructions

```text
Implement Observability, Reliability and Recovery for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: NFR-OPS-001; HLD sections 12-14; LLD sections 12-14.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P33 - Security Hardening and Supply Chain

### Objective

Implement secure SDLC controls, ASVS-mapped tests, upload hardening, secret handling, artifact signing, SBOM, dependency/container scanning and production admission policies.

### Controlled references

`NFR-SEC-001; HLD section 9 and 14; LLD sections 10 and 13`

### Required implementation scope

security backlog, CI/CD gates, threat model, control tests, evidence pack.

### Feature-specific instructions

```text
Implement Security Hardening and Supply Chain for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: NFR-SEC-001; HLD section 9 and 14; LLD sections 10 and 13.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

## P34 - Accessibility, Performance and Final End-to-End Verification

### Objective

Verify WCAG 2.2 AA primary journeys, 500-workload scale, golden scenarios, sensitivity, reconciliation, resilience, recovery and release gates.

### Controlled references

`AIS-RTMVP-001; VS-REQ to VS-TRC; G-01 to G-12`

### Required implementation scope

automated/manual test suites, evidence records, coverage report, release gate summary.

### Feature-specific instructions

```text
Implement Accessibility, Performance and Final End-to-End Verification for the AI Infrastructure Sizing Platform.

First apply the Universal Prompt Execution Contract. Then:
1. Inspect existing implementation and identify reusable compliant patterns.
2. Map every change to the controlled references: AIS-RTMVP-001; VS-REQ to VS-TRC; G-01 to G-12.
3. Implement the complete vertical slice across UI, API, domain, persistence, asynchronous processing, audit, trace and tests as applicable.
4. Preserve all Non-Negotiable Product Guardrails.
5. Use governed catalogs, evidence, Formula IDs and policy versions. Do not hard-code missing business rules.
6. Include negative, boundary, authorization, tenant-isolation, idempotency, concurrency and error-path tests where applicable.
7. Add user-facing explanations for why data is required, allowed values, validations, formula or decision impact, source/evidence and confidence where applicable.
8. Complete the feature-specific checkpoint below and then the Universal checkpoint.
```

### Feature checkpoint

- [ ] Scope and controlled references are fully mapped.
- [ ] The vertical slice is complete, with no disconnected UI or backend stub.
- [ ] Business rules are deterministic and server authoritative.
- [ ] Governed missing-data behavior is visible and tested.
- [ ] Objective evidence is attached to the applicable verification case.
- [ ] No change unintentionally affects other environments, objectives or workloads.

---

# 7. Cross-Feature Review Prompt

Run after every three to five feature prompts:

```text
Perform a cross-feature architecture and product-consistency review for the features completed since the previous review.

Review:
- requirement coverage and unresolved conflicts;
- domain ownership and dependency violations;
- duplicated formulas, policies, catalog values or UI components;
- inconsistent field IDs, units, statuses, enums or error codes;
- broken Development versus Production separation;
- broken Performance versus Price objective continuity;
- HA/DR double counting;
- missing trace, evidence, audit or readiness behavior;
- unauthorized cross-tenant access paths;
- accessibility regressions;
- API/schema compatibility;
- calculation determinism, idempotency and reproducibility;
- BOM and financial reconciliation;
- test gaps and flaky tests.

Produce a prioritized corrective-action list. Apply corrections that are within the reviewed feature scope. Do not conceal unresolved items. End with the Universal checkpoint.
```

---

# 8. Pull Request Review Prompt

```text
Review this pull request against the controlled AI Infrastructure Sizing Platform baseline.

Return:
1. requirement IDs implemented;
2. missing acceptance criteria;
3. architecture and domain-boundary issues;
4. deterministic calculation or governed-data violations;
5. security and tenant-isolation findings;
6. accessibility findings;
7. API, migration, queue and concurrency risks;
8. traceability and audit gaps;
9. test adequacy, including negative, property, golden, sensitivity and reconciliation coverage;
10. release-gate impact.

Grade findings as Critical, High, Medium or Low. Do not approve when a Critical or High finding is unresolved. Do not treat compilation or unit-test success alone as feature completion.
```

---

# 9. Final System Verification Prompt

```text
Execute the final system-verification review against AIS-RTMVP-001.

Verify:
- all 124 controlled requirements are mapped;
- all mandatory verification cases are executed;
- all 12 golden scenarios reproduce exact expected outputs and trace;
- material input sensitivity changes intended downstream recommendations;
- model override performs complete recalculation;
- no random or unsupported selection exists;
- no circular or hidden calculation dependency exists;
- Development and Production are separated;
- Performance and Price objectives remain visible end to end;
- compatibility aggregation occurs before rounding;
- HA, maintenance and DR are applied once;
- server and cloud outputs reference exact deployable configurations;
- missing prices are never treated as zero;
- BOM and financial totals reconcile;
- tenant isolation passes at API, service, database and artifact layers;
- WCAG 2.2 AA primary journeys pass automated and manual checks;
- 500-workload performance test passes approved thresholds;
- duplicate messages, retries, failover, restore and unfinished-job reconstruction pass;
- evidence, audit and export hashes are retained;
- all G-01 through G-12 release gates are approved.

Generate the immutable release evidence pack. If any gate fails or is missing evidence, mark the release BLOCKED and list exact owner actions.
```

---

# 10. Standards References

- NIST SP 800-218 Secure Software Development Framework, stable Version 1.1. A Version 1.2 revision is still an initial public draft as of this prompt-pack date.
- OWASP Application Security Verification Standard 5.0.0.
- W3C Web Content Accessibility Guidelines 2.2, target Level AA.
- OpenAPI Specification 3.2.x with a pinned patch selected through ADR and tooling validation.
- The platform-specific HLD, LLD and Verification Plan remain authoritative when they are stricter than generic framework guidance.

---

# 11. Maintenance Rules for This Prompt File

- Update this file only through version control and review.
- Preserve Prompt IDs. Supersede prompts rather than silently renumbering them.
- Add requirement IDs to a prompt before extending feature scope.
- Record the baseline document versions at every major release.
- When an ADR changes a technology choice, update only technology-specific instructions, not product guardrails.
- When formulas or policies change, update the referenced controlled specification and verification evidence before changing implementation prompts.
- Never use this file as a substitute for the controlled requirements and formula specifications. It orchestrates implementation; it does not redefine product truth.
