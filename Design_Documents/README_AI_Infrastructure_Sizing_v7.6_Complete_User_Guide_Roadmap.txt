AI INFRASTRUCTURE SIZING WORKBOOK v8.3
DETAILED README, LOGIC REFERENCE, LIMITATIONS, AND FUTURE ROADMAP
=================================================================

Document date: 18 September 2026
Workbook documented: AI_Infrastructure_Sizing_v8.3_Clear_Executive_BOM.xlsx
README purpose: Explain what the workbook does, why each calculation exists, how information flows through every sheet, what assumptions are currently used, what is incomplete, and what must be improved in future releases.

IMPORTANT STATUS STATEMENT
--------------------------
This workbook is a deterministic planning and architecture-sizing prototype. It is not yet a procurement-authorized system, a benchmark certification tool, or a substitute for an OEM configuration, supplier quotation, cloud-provider price export, storage design, network topology design, or measured production load test.

The workbook is designed to prevent random selection. It evaluates governed model, precision, GPU, server, capacity, availability, disaster recovery, storage, networking, clustering, BOM, and financial rules. However, several catalog values and planning constants are static approximations. All recommendations must therefore be treated according to their evidence status.

The workbook can be used for:
1. Early-stage AI infrastructure planning.
2. Comparing Performance-Optimized and Price-Optimized compliant configurations.
3. Separating Development and Production infrastructure.
4. Estimating model memory, request throughput, training demand, GPU quantity, server quantity, storage, network, HA, DR, and planning costs.
5. Consolidating compatible workloads into shared node pools.
6. Producing an executive planning BOM and a detailed procurement-oriented BOM structure.
7. Showing traceability from inputs to formulas, catalogs, recommendations, and limitations.

The workbook must not yet be used to:
1. Issue a purchase order without OEM validation and dated quotations.
2. Approve a cloud budget without exact provider, region, SKU, pricing model, and current unit price.
3. Guarantee latency, throughput, TTFT, tokens/second, training completion time, availability, recovery time, or recovery point.
4. Treat planning benchmark values as measured customer-environment results.
5. Treat the current cluster consolidation factors as workload-schedule evidence.

=================================================================
1. WORKBOOK DESIGN PRINCIPLES
=================================================================

1.1 Single input surface
Only Sheet 1 is intended for business-user input. Later sheets are calculation, catalog, output, traceability, and testing layers.

1.2 Deterministic selection
The workbook does not intentionally choose a model, GPU, server, or cloud configuration randomly. Each choice is expected to result from explicit compatibility and eligibility filters, followed by an optimization rule.

1.3 Two sizing options
The workbook generates two separate on-premises choices:

Performance-Optimized:
Selects the highest-performing eligible hardware option after memory, capacity, mode, lifecycle, and vendor filters pass. Lower cost is used only as a tie-break where applicable.

Price-Optimized:
Selects the lowest-cost eligible deployable option after all mandatory constraints pass. Higher performance is used only as a tie-break where applicable.

Price-Optimized does not mean cheapest hardware regardless of suitability. An option must first satisfy the required memory, throughput or training deadline, supported workload mode, vendor preference, and lifecycle rules.

1.4 Development and Production separation
Development and Production are calculated as separate environments.

Development is intended for experimentation, prompt engineering, RAG validation, application development, integration testing, limited model evaluation, and controlled fine-tuning.

Production is intended for real workload demand and includes growth, availability reserve, disaster recovery, production-grade shared infrastructure, and consolidated physical deployment.

1.5 Workload-level sizing followed by cluster-level consolidation
The workbook first calculates demand for each workload. It then classifies each workload into a node pool and consolidates compatible workloads at environment, node-pool, scenario, and selected-option level.

The intended flow is:

Executive inputs
-> workload mapping
-> token and model calculations
-> memory and capacity calculations
-> per-option hardware evaluation
-> Performance-Optimized and Price-Optimized selections
-> Development and Production allocation
-> node-pool consolidation
-> physical server quantity
-> shared infrastructure BOM
-> executive financial output
-> traceability and tests

1.6 Evidence-aware outputs
The workbook uses evidence status and limitation fields to distinguish a planning baseline from a procurement-ready record. A recommendation that lacks a current quote, matched benchmark, exact cloud price, or supported OEM configuration should not be presented as fully procurement ready.

=================================================================
2. SHEET-BY-SHEET DESCRIPTION
=================================================================

2.1 SHEET 1: EXECUTIVE INPUTS
--------------------------------
Purpose:
Capture global planning choices and workload-specific requirements. This is the only intended user-input sheet.

Capacity:
Rows 12 to 511 support up to 500 workload records.

Global inputs:

Deployment Type
Allowed values: On-Premises, Cloud, Hybrid.
Why required: Determines which BOM and financial path should be used.
Current limitation: The on-premises path is more developed than the cloud path. Cloud and Hybrid outputs are not complete until exact cloud data is populated.

Availability Requirement
Allowed values: Standard, High Availability, Fault Tolerant.
Why required: Determines production reserve.
Current governed factors:
- Standard = 1.00x
- High Availability = 1.25x
- Fault Tolerant = 2.00x
Important: These are planning policies, not universal architectural truths. Future releases should derive capacity from explicit failure-domain and N+1/N+2 rules.

DR Requirement
Allowed values: None, Cold, Warm, Hot.
Why required: Determines DR compute fraction and storage protection expectations.
Current active compute fractions:
- None = 0.00
- Cold = 0.00
- Warm = 0.50
- Hot = 1.00
Important: Cold DR still requires protected data, tested restore procedures, infrastructure-as-code, and recovery planning even when active DR compute is zero.

Planning Period
Allowed values: 1, 3, or 5 years.
Why required: Compounds workload and data growth.
Current default annual workload growth: 20%.
Current default annual data growth: 20%.

Currency
Current displayed value: USD.
Why required: Controls financial display.
Current limitation: Currency conversion and exchange-rate governance are not implemented.

Preferred GPU Vendor
Allowed values: No Preference, NVIDIA, AMD, Intel.
Why required: Filters eligible hardware options.
Important: This is an eligibility filter. It should never force an incapable option to pass.

Workload inputs:

Workload ID
Unique identifier used across all calculation and traceability sheets.

Industry
Maps the workload into the governed use-case catalog.
Current allowed industries include Banking, Insurance, Healthcare, Retail, Manufacturing, Telecommunications, Government, Education, Energy and Utilities, and Transportation and Logistics.

Use Case
Selects the workload mapping, demand unit, modality, model tier, token profile, pool, and capacity interpretation.
Critical governance requirement: Every supported use case must exist in the governed use-case catalog. An unmapped use case must return UNMAPPED or REVIEW rather than silently using a default.

Workload Share %
Represents the workload's share where a common demand total is distributed across multiple relevant workloads.
Why required: Prevents every workload from incorrectly receiving the entire shared demand.
Current limitation: The workbook validates workload distribution at row level but needs stronger group-level validation by shared demand source.

Simple %, Medium %, Complex %
Represents the expected usage mix for request complexity.
Required rule: Simple + Medium + Complex must equal 100%.
Why required: Token estimation is a weighted average of governed token tiers. Different complexity mixes change input tokens, output tokens, context, memory, throughput, and BOM.

Total %
Calculated validation total for the complexity mix.

Demand Value
Numeric workload volume.
Examples: concurrent sessions, events per second, pages per hour, transactions per hour, camera streams, audio hours per day, or training tokens.

Demand Unit
Defines the semantic conversion from business demand to request rate, throughput, or training demand.
Critical principle: A unit must only be converted using a rule appropriate to the use case. Camera streams, concurrent sessions, pages per hour, and training tokens are not interchangeable.

Language Coverage
Allowed values include English only, English + Regional, and Global multilingual.
Why required: Language affects model eligibility, tokenization, context, and potentially output quality.
KNOWN DEFECT: In v8.3, the Language Class calculation in Sheet 2 currently returns Regional for both branches. This means language coverage does not yet correctly differentiate English-only, regional, and global multilingual workloads. This must be corrected in the next release.

File Types
Captures source content modality and ingestion implications.
Examples: PDF, Word, Excel, plain text, images, video.
Why required: File type affects modality, extraction, parsing, OCR, chunking, storage, and retrieval design.
Current limitation: File Types is not yet fully connected to parser capacity, OCR capacity, ingestion throughput, or storage expansion factors.

Workload Mode
Allowed values: Inference, Fine-tuning, Training.
Why required: Changes the capacity equation, supported platform filter, GPU interconnect requirement, and completion-time logic.

Model Override
Optional user-selected model.
Why required: Allows a governed override after a recommendation is produced.
Required behavior: An override must recalculate precision, memory, GPU fit, capacity, server quantity, HA, DR, BOM, and financials.
Current limitation: Override compatibility and reason validation should be tested more comprehensively.

Override Reason
Mandatory when Model Override is populated.
Why required: Creates auditability and prevents unexplained selection changes.

Typical Request
Describes what one transaction contains.
Why required: Helps define input-token demand.
Current limitation: The current workbook uses governed use-case token tiers rather than tokenizing entered text directly.

Supporting Context
Describes retrieved or attached supporting information.
Why required: Drives context and retrieval-token requirements.

Conversation History
Allowed patterns include None or governed history classes.
Why required: Adds retained conversation context to each model call.

Expected Answer Type
Examples: concise answer, detailed answer, classification, grounded answer, alert plus summary, code or structured output.
Why required: Influences output-token profile and model suitability.

Tool / Agent Usage
Allowed values: None, Basic tools, Multi-step agent.
Why required: Tool use can add model calls and tool-related tokens.
Current limitation: Tool-call counts are approximated by governed categories rather than measured workflow traces.

Prompt Caching Permitted
Allowed values: Yes or No.
Why required: Can affect effective input-processing demand and cloud/serving economics.
Current limitation: Cache-hit rate and provider-specific cached-token pricing are not implemented.

Model Calls / Transaction
Allowed governed choices include 1, 2, 3, 4, 5, 6, 8, and 10.
Why required: A user action can trigger multiple model calls, especially for agents or multi-stage RAG.
Impact: Multiplies request rate and total token processing.

Training Tokens (B)
Training or fine-tuning dataset size in billions of tokens.
Why required: Used in the training-compute equation.

Epochs
Number of passes over training data.
Why required: Training compute scales approximately linearly with epochs.

Completion Target Hours
Required completion window for training or fine-tuning.
Why required: Converts total training compute into required accelerator count.

Knowledge Content GB
Direct knowledge-base content volume.
Why required: RAG storage must be based on content volume, not model parameter count.

Knowledge Content Tier
Allowed values: Small, Medium, Large, Enterprise.
Why required: Provides a governed fallback when exact content volume is unavailable.
Current fallback values used by the capacity engine should be treated as planning approximations and must be verified.

Retention Days
Affects storage for logs, indexes, intermediate data, and protected copies.
Current limitation: Retention is not fully decomposed by data class.

Availability Override and DR Override
Allow workload-level override of global availability and DR settings.
Why required: Different workloads may have different criticality.

Development Required and Production Required
Independent Yes/No flags.
Why required: A workload may require only Development, only Production, or both.

Workload Notes
Free-text context.

Mapping Status
Calculated. Shows whether industry/use case mapping exists.

Input Status
Calculated. Shows PASS, FAIL, or INACTIVE based on mandatory inputs and validation.

Active?
Calculated or controlled status used to prevent inactive rows from contributing downstream.

2.2 SHEET 2: MODEL SELECTION
--------------------------------
Purpose:
Convert business workload descriptions into workload type, demand unit, token profile, context requirement, model recommendation, final model, precision, architecture parameters, and memory estimates.

Main outputs:
- Workload Type
- Node Pool
- Demand Unit
- Modality
- Model Tier
- Language Class
- Simple, Medium, and Complex input/output token tiers
- Weighted input and output tokens
- Tool tokens
- History tokens
- Retrieved tokens
- Total context
- Recommended Model
- Final Model after optional override
- Parameters
- Context limit
- Layer count
- Hidden size
- Performance precision
- Price precision
- Bytes per parameter
- Batch proxy
- Weight memory
- Model status

Token logic:

Weighted Input Tokens =
(Simple % x Simple Input Tier)
+ (Medium % x Medium Input Tier)
+ (Complex % x Complex Input Tier)

Weighted Output Tokens =
(Simple % x Simple Output Tier)
+ (Medium % x Medium Output Tier)
+ (Complex % x Complex Output Tier)

Tool Tokens, History Tokens, and Retrieved Tokens are then added according to governed rules.

Total Context is the combined in-flight context used for eligibility and memory planning.

Why this is calculated:
Tokens drive input TPS, output TPS, context-window eligibility, KV cache, memory fit, request latency risk, serving replicas, and cost.

Model recommendation logic:
The workbook maps workload characteristics to a governed model catalog. It uses a composite key based on model tier, modality class, and language class.

Final Model logic:
If a valid Model Override exists, the override should become the final model. Otherwise, the governed recommended model is used.

Precision logic:
The workbook has separate precision paths for Performance-Optimized and Price-Optimized scenarios. Precision changes bytes per parameter and therefore model weight memory, memory fit, GPU count, and cost.

Weight memory:
Model Weight GiB = Parameters in billions x Bytes per Parameter x 1,000,000,000 / 2^30

Why weight memory is calculated:
The model weights must fit in usable accelerator memory together with KV cache and runtime overhead.

Model status:
Should return a review state when mapping, context, architecture, or compatibility is unresolved.

Current limitations and required corrections:
1. Language Class formula currently always returns Regional. This is a material defect.
2. Token tiers are planning values, not direct tokenizer measurements from entered requests.
3. The governed model catalog is small and must be versioned and expanded carefully.
4. Architecture details must be refreshed from actual model cards.
5. Context eligibility should account for implementation-specific limits and reserved system tokens.
6. Precision support must be validated against model, serving runtime, hardware, and quality evidence.
7. Prompt caching needs an explicit cache-hit-rate model.
8. Model override regression tests must prove that every downstream field recalculates.

2.3 SHEET 3: CAPACITY ENGINE
--------------------------------
Purpose:
Convert model and workload demand into request rate, token throughput, training compute, GPU quantity, server quantity, HA, DR, storage, network, and final per-workload hardware planning values.

Growth factor:
Growth Factor = (1 + Annual Workload Growth)^Planning Years
Current annual workload growth default = 20%.

Why calculated:
Infrastructure should cover the selected planning horizon rather than only today's demand.

Availability factor:
Global or workload-level availability selection is translated into a production reserve factor.

DR fraction:
Global or workload-level DR selection is translated into the active DR compute fraction.

Planning RPS:
Business demand is converted to requests per second using the governed demand-unit/activity-rate rule.

Why calculated:
Request rate is required to estimate input and output token throughput.

Input TPS:
Input TPS = Planning RPS x Input Tokens x Model Calls per Transaction

Output TPS:
Output TPS = Planning RPS x Output Tokens x Model Calls per Transaction

Why calculated:
Accelerators have separate input-processing and output-generation throughput constraints. The larger required GPU count governs.

Training FLOPs:
Training FLOPs = 6 x Model Parameters x Training Tokens x Epochs

Why calculated:
Provides a dense-transformer planning estimate for training or fine-tuning compute.

Training GPU requirement:
Training GPUs = CEILING(Training FLOPs / (Effective GPU FLOP/s x Allowed Completion Seconds), 1)

Why calculated:
The same training job may require different GPU counts depending on the completion deadline.

Base GPU requirement:
Base GPUs = MAX(Memory GPUs, Throughput GPUs, Training GPUs)

Why calculated:
A configuration must satisfy all binding constraints. It is unsafe to size only by model memory or only by throughput.

Base servers:
Base Servers = CEILING(Base GPUs / GPUs per Server, 1)

Production servers:
Production Servers = CEILING(Base Servers x HA Factor, 1)

DR servers:
DR Servers = CEILING(Production Servers x DR Active Fraction, 1)

Total servers:
Total Servers = Production Servers + DR Servers

GPU quantity:
Physical GPU Quantity = Total Servers x GPUs per Server

Why server-deployable quantities are used:
Procurement is based on whole servers and installed accelerators, not fractional theoretical GPU requirements.

Primary storage:
Primary Storage = (Content + Vector/Index + Training + Logs) x Growth x Replication

Current data growth default = 20% annually.
Current primary storage replication planning factor = 2x.

Why calculated:
The RAG knowledge base, training data, indexes, logs, and protected copies require capacity independent of model parameter size.

North-south bandwidth:
North-South Gbps = RPS x (Request KB + Response KB) x 8 / 1,000,000 x Network Headroom
Current network headroom = 1.3x.

Fabric tier:
Assigned based on workload mode and deployed GPU quantity. Larger training and high-end multi-GPU pools require faster fabric.

Current limitations:
1. Demand conversion rates need measured business activity data.
2. TTFT, inter-token latency, batching behavior, queueing, and P95/P99 latency are not fully modelled.
3. Input and output benchmarks are static baselines, not matched target-stack results.
4. Training effective PFLOPS and utilization require measured MFU.
5. Storage compression, deduplication, index growth, replication topology, snapshots, and backup retention require detailed design.
6. East-west collective traffic is not calculated from actual parallelism strategy.
7. RTO and RPO are not explicit inputs.
8. HA factors should be replaced by failure-domain logic.

2.4 SHEET 4: OPTION EVALUATION
--------------------------------
Purpose:
Evaluate every active workload against every hardware option in the governed hardware catalog.

Scale:
500 workload rows x 15 hardware options = 7,500 evaluation rows.

Eligibility checks:
- Workload mode supported by the server/GPU option.
- GPU vendor matches user preference or No Preference is selected.
- Hardware lifecycle is eligible, currently indicated by GA.
- Model and KV/runtime memory fit in usable GPU memory.
- Input token throughput fits.
- Output token throughput fits.
- Training completion target fits where applicable.
- Required GPU quantity can be deployed as whole servers.

Memory GPU calculation:
Memory GPUs = CEILING(Runtime Memory Requirement / Usable Memory per GPU, 1)

Throughput GPU calculation:
Throughput GPUs = CEILING(MAX(Input TPS / Input TPS per GPU, Output TPS / Output TPS per GPU), 1)

Training GPU calculation:
Training GPUs = CEILING(Training FLOPs / Effective GPU Compute over Deadline, 1)

Total required GPUs:
Total GPUs = MAX(Memory GPUs, Throughput GPUs, Training GPUs)

Servers:
Servers = CEILING(Total GPUs / GPUs per Server, 1)

Deployable GPUs:
Deployable GPUs = Servers x GPUs per Server

Cost:
Deployable Cost = Servers x Configured Server Price

Performance selection:
Highest eligible performance score, with cost tie-break logic.

Price selection:
Lowest eligible deployable cost, with performance tie-break logic.

Why this sheet exists:
It provides a transparent candidate matrix and prevents selecting one GPU for every workload without checking alternatives.

Current limitations:
1. Performance Score is a catalog planning score and not a universal benchmark.
2. TPS values are static and need model, precision, batch, sequence-length, runtime, and GPU-specific benchmark matching.
3. Server configured prices are planning baselines.
4. PCIe/SXM topology, NVLink/NVSwitch, CPU bottlenecks, NUMA, storage I/O, and network topology need deeper eligibility checks.
5. Thermal, power, rack, and data-center constraints are not evaluated.

2.5 SHEET 5: HARDWARE CATALOG
--------------------------------
Purpose:
Hold governed on-premises server/GPU options and planning attributes.

Current catalog fields:
- Option ID
- Server vendor
- Server platform
- GPU vendor
- GPU SKU
- GPU memory
- Usable memory percentage
- GPUs per server
- Supported workload modes
- Lifecycle
- Performance score
- Input TPS per GPU
- Output TPS per GPU
- Effective PFLOPS per GPU
- GPU TDP
- Server base price
- GPU unit price
- Configured price
- Fabric capability
- Source URL
- Evidence status
- Compatibility note

Why this catalog exists:
Calculations require a controlled set of deployable server configurations rather than arbitrary GPU names.

Current limitations:
1. Exact CPU SKU, socket count, core count, RAM DIMM layout, boot storage part numbers, local NVMe part numbers, RAID/HBA, NIC/DPU, optics, cables, PSU, rack, and support SKUs are not fully catalogued as orderable part numbers.
2. Configured price values must be replaced with dated OEM or partner quotations.
3. Compatibility must be backed by current OEM technical guides and supported accelerator matrices.
4. Platform lifecycle status must be refreshed.
5. Benchmarks must be matched to model, precision, runtime, batch, input length, output length, and service-level objective.
6. Power and cooling information is not used in primary financials.

2.6 SHEET 6: CLOUD CATALOG
--------------------------------
Purpose:
Provide the structure for 50 records: 5 providers x 10 service categories.

Providers:
- AWS
- Azure
- GCP
- OCI
- Yotta Shakti Cloud

Service categories:
- GPU Compute
- Object Storage
- Block Storage
- File Storage
- Vector Database
- Managed Kubernetes
- Load Balancer
- Monitoring
- Backup
- Data Transfer

Current fields:
Provider, category, resource, accelerator, quantity, memory per GPU, region, unit price, currency, price date, source URL, and notes.

Current status:
The cloud catalog is a placeholder framework. Resource names, quantities, regions, and prices are not populated with exact live provider records.

Critical implication:
Cloud outputs must remain NOT PROCUREMENT READY until provider, region, exact SKU/service, billing unit, quantity, operating hours, storage, IOPS/throughput, data transfer, price, price date, currency, and source are populated.

2.7 SHEET 7A: CLUSTER CONSOLIDATION
--------------------------------
Purpose:
Allocate workloads to Development and Production node pools and prevent one-server-per-workload double counting.

Environments:
- Development
- Production

Scenarios:
- Performance
- Price
These map to Performance-Optimized and Price-Optimized in the executive output.

Node pools:
- General-Inference
- Large-Model-Inference
- Multimodal-Vision
- Training-FineTune

Current pool assignment:
- Training or Fine-tuning -> Training-FineTune
- Multimodal workload -> Multimodal-Vision
- Model tier at or above the configured large threshold -> Large-Model-Inference
- Remaining compatible inference -> General-Inference

Development demand rule:
Current Development base GPU demand is 15% of the workload's selected base GPU demand, with a minimum of one GPU for an active Development allocation.

Production demand rule:
Production uses 100% of selected base GPU demand.

Coincidence factor:
Current default = 1.0.

Concurrent GPU demand:
Concurrent GPU Demand = Workload Base GPUs x Coincidence Factor

Target utilization:
Current default = 0.75.

Allocated pool GPUs:
Allocated Pool GPUs = CEILING(Concurrent GPU Demand / Target Utilization, 1)

Why these are calculated:
The workbook sizes each workload, then groups compatible workloads into shared pools. This allows multiple applications to run on one server or cluster where technical conditions permit.

Critical current limitations:
1. The 15% Development factor is hardcoded and is not driven by an executive input or measured Development plan.
2. Coincidence factor is fixed at 1.0 and does not yet use workload schedules or overlapping peaks.
3. Target utilization is fixed at 75% and should be governed by workload type, SLA, scheduler, and benchmark evidence.
4. Pool compatibility key does not yet include all required controls such as security zone, data residency, runtime version, model-serving stack, precision, tenancy, regulatory isolation, and network fabric.
5. GPU sharing/MIG/time-slicing eligibility is described but not calculated at profile level.
6. Consolidation should occur at pool aggregate before rounding wherever technically safe. Current allocation-level rounding may still overstate capacity.
7. Production HA and DR must be applied once at the final pool/failure-domain level. Future releases should verify there is no duplicate reserve between workload and BOM layers.

2.8 SHEET 7B: PROCUREMENT BOM
--------------------------------
Purpose:
Convert consolidated node-pool demand into on-premises compute BOM, shared infrastructure BOM, and cloud billable-service structure.

On-premises compute fields:
- BOM ID
- Environment
- Scenario
- Node pool
- Cluster ID
- Server vendor
- Server platform
- Server quantity
- GPU vendor
- GPU SKU
- GPUs per server
- Total GPUs
- GPU memory per server
- CPU configuration
- System RAM
- Boot storage
- Local data/cache
- Network adapters
- Fabric
- Power supplies
- OS/hypervisor
- Container platform
- AI runtime/software
- Support term
- Unit price
- Extended price
- Evidence status
- Source/limitation

Server quantity logic:
Server Quantity = CEILING(Pool Required GPUs / GPUs per Server x Production Reserve and DR logic, 1)

Extended price:
Extended Price = Server Quantity x Unit Planning Price

Shared infrastructure categories:
- Primary AI storage
- Backup/DR repository
- AI fabric switches
- Optics and cables
- Management/control-plane nodes
- AI platform and monitoring

Why shared infrastructure is separated:
Shared infrastructure should be counted once per environment and scenario, not once per workload.

Cloud BOM fields include environment, scenario, provider, region, service category, exact SKU, accelerator, accelerators per instance, instance quantity, hours per month, storage, data transfer, unit price, monthly cost, planning-period cost, evidence status, and procurement note.

Critical limitations:
1. CPU configuration, RAM, boot storage, local data, NIC/DPU, power, OS, and software are mostly planning descriptions, not exact orderable line items.
2. Shared infrastructure quantities use planning rules and need architecture validation.
3. Cabling/optics must be calculated from an actual topology and port map.
4. Storage requires service-level, throughput, IOPS, data-protection, and retention design.
5. Cloud BOM values remain placeholders.
6. Tax, freight, implementation, professional services, rack integration, facilities, and support escalation are not fully included.
7. License metrics may differ by GPU, CPU, node, user, or subscription and need vendor validation.

2.9 HIDDEN SHEET 7: BOM FINANCIALS
--------------------------------
Purpose:
Retains the earlier workload-level consolidated financial calculation layer.

Status:
Hidden from the executive user because Sheet 8 is intended to be clearer.

Important maintenance note:
This hidden sheet still contains many formulas and may continue feeding other outputs. It must remain regression-tested. In a future redesign, duplicate or obsolete calculation layers should be removed to reduce maintenance risk.

2.10 SHEET 8: EXECUTIVE BOM FINANCIALS
--------------------------------
Purpose:
Present clear decision-ready summaries without exposing formula IDs or technical calculation detail.

Executive combinations:
- Development Performance-Optimized
- Development Price-Optimized
- Production Performance-Optimized
- Production Price-Optimized

Decision summary fields:
Environment, sizing option, deployment path, cluster, active node pools, servers, GPUs, compute, storage and backup, network, platform and software, total on-premises CAPEX, cloud monthly, cloud planning-period cost, purchase readiness, purpose, primary cost driver, and key limitation.

Financial comparison:
Compares Development, Production, and combined totals across the two optimization objectives.

Complete on-premises node-pool BOM:
Shows the selected server/vendor/GPU configuration and quantities by environment, scenario, cluster, and node pool.

Shared infrastructure BOM:
Shows storage, network, management, and software components separately.

Cloud readiness:
Shows provider-level readiness, but remains incomplete until the cloud catalog is populated.

Workload-to-cluster allocation:
Explains which workload is assigned to which environment and node pool.

Why this sheet exists:
An executive should be able to answer:
- What is required for Development?
- What is required for Production?
- Which option prioritizes performance?
- Which option minimizes compliant cost?
- Which workloads share infrastructure?
- How many servers and GPUs are required?
- What are the total planning costs?
- Is the output ready for procurement?

Important interpretation:
Performance-Optimized means the highest-performing eligible configuration.
Price-Optimized means the lowest-cost configuration that still satisfies the defined constraints.

Current limitations:
1. Purchase readiness is planning-oriented and must not be confused with approved procurement status.
2. Cloud totals remain zero or incomplete while live cloud records are missing.
3. Costs do not yet include every commercial and facilities item.
4. The executive sheet currently displays only a limited allocation window rather than all active workloads dynamically.
5. Workload lists were replaced with workload counts in some BOM rows to avoid unstable array formulas. Detailed names are available in the allocation section.

2.11 SHEET 9: TRACEABILITY
--------------------------------
Purpose:
Provide end-to-end audit linkage for every material output.

Fields:
Trace ID, workload ID, output, value, input source, catalog source, formula ID, evidence status, source URL, override impact, scenario, version, and limitations.

Tracked output types include:
- Final Model
- Performance GPU
- Price GPU
- Primary Storage
- Fabric Tier
- Additional recommendation and BOM records

Why this sheet exists:
A reviewer should be able to identify what input, catalog, formula, evidence, and limitation produced a recommendation.

Current limitations:
1. Traceability version values still show 8.0 in some rows and should be updated to 8.3.
2. Traceability should include direct cell addresses for source and destination.
3. Catalog row IDs and evidence snapshot IDs should be immutable.
4. Formula hashes or release signatures are not implemented.

2.12 SHEET 10: LOGIC TESTS
--------------------------------
Purpose:
Maintain formula documentation, governed constants, use-case mappings, model catalog, infrastructure policy, and automated validation tests.

Formula IDs:
TOK-101: Weighted input tokens.
TOK-102: Weighted output tokens.
MEM-101: Model weight memory.
MEM-102: KV cache memory.
MEM-103: Runtime memory with overhead and safety.
CAP-101: Business demand to request rate.
CAP-102: Throughput GPU requirement.
TRN-101: Training FLOPs.
TRN-102: Training GPU requirement.
CAP-103: Base GPU requirement from maximum binding constraint.
HA-101: Production server reserve.
DR-101: DR server requirement.
STO-101: Primary storage.
NET-101: North-south network bandwidth.
NET-102: Fabric tier.
BOM-101: Extended cost.
SEL-101: Performance option selection.
SEL-102: Price option selection.
CLSTR-101/CLSTR-102: Cluster compatibility and pool capacity logic where present.
BOM-201/CLOUD-201: Procurement and cloud BOM logic where present.

Current governed constants:
- Annual workload growth: 20%.
- Annual data growth: 20%.
- Standard availability factor: 1.00x.
- High Availability factor: 1.25x.
- Fault Tolerant factor: 2.00x.
- None/Cold DR compute fraction: 0%.
- Warm DR compute fraction: 50%.
- Hot DR compute fraction: 100%.
- Runtime memory overhead: 10%.
- Memory safety margin: 15%.
- Primary storage replication: 2x.
- Network headroom: 1.3x.
- Development demand factor in cluster sheet: 15%.
- Target pool utilization in cluster sheet: 75%.
- Coincidence factor in cluster sheet: 100%.

Important:
Every policy constant must have an owner, effective date, evidence, review date, override rule, and approved range in a future release.

=================================================================
3. COMPLETE END-TO-END CALCULATION FLOW
=================================================================

Step 1: Validate global inputs.
Deployment, availability, DR, planning period, currency, and vendor preference are checked against controlled values.

Step 2: Validate each workload.
An active workload requires a valid industry/use case mapping, complexity total of 100%, applicable demand, language, file type, expected answer type, environment flags, and other mandatory profile information.

Step 3: Map industry and use case.
The governed catalog returns workload type, demand unit, node pool, modality, model tier, and token tiers.

Step 4: Calculate the request profile.
Complexity percentages weight simple, medium, and complex token tiers. Tool, history, retrieval, and model-call effects are added.

Step 5: Select a recommended model.
The workload tier, modality, language class, and model catalog determine the recommended model.

Step 6: Apply optional model override.
The override becomes the final model only through governed logic and should trigger complete downstream recalculation.

Step 7: Select scenario precision.
Performance and Price scenarios may use different compatible precision settings. Precision changes bytes per parameter, memory, GPU fit, and throughput assumptions.

Step 8: Calculate model weight and runtime memory.
Model weights, KV cache, runtime overhead, and safety margin determine memory GPU requirements.

Step 9: Convert demand to request rate or training compute.
Inference/RAG uses request-rate and token-throughput logic. Training/Fine-tuning uses dataset size, epochs, model size, effective GPU compute, and deadline.

Step 10: Apply growth.
Workload and data demand are compounded over the selected planning period.

Step 11: Evaluate every hardware option.
Each candidate is checked for workload-mode support, vendor preference, lifecycle, memory, throughput/training, and deployability.

Step 12: Select two eligible options.
Performance-Optimized chooses the best performance score. Price-Optimized chooses the lowest compliant deployable cost.

Step 13: Calculate Development and Production allocations.
Development currently uses 15% of selected base demand with a minimum of one GPU. Production uses full selected demand.

Step 14: Assign node pools.
Workloads are grouped as General Inference, Large Model Inference, Multimodal/Vision, or Training/Fine-tuning.

Step 15: Consolidate capacity.
Concurrent demand and target utilization calculate pool GPU requirements.

Step 16: Convert pool GPUs to physical servers.
Whole servers are calculated using the selected platform's GPUs per server.

Step 17: Apply Production availability and DR.
Production reserves and DR capacity are added according to global or workload policy.

Step 18: Calculate shared storage, network, management, and software.
Shared components are intended to be counted once per environment and scenario rather than once per workload.

Step 19: Calculate financials.
Quantity x unit planning price produces extended cost. Costs are summarized by Development, Production, Performance-Optimized, and Price-Optimized.

Step 20: Display readiness and limitations.
Outputs must indicate whether they are planning ready, quote required, review required, or not procurement ready.

=================================================================
4. WHY THE WORKBOOK CALCULATES EACH MAJOR ELEMENT
=================================================================

Tokens:
Needed because AI capacity is driven by how much text or multimodal context enters and leaves the model, not only by user count.

Context window:
Needed to reject models that cannot support the request, history, retrieval, and tool context.

Model parameters and precision:
Needed because weight memory depends on model size and bytes per parameter.

KV cache:
Needed because serving memory increases with concurrent context and architecture.

Request rate:
Needed to translate business usage into technical throughput.

Input TPS and Output TPS:
Needed because prompt processing and token generation have different bottlenecks.

Training FLOPs and deadline:
Needed because the same training workload can require more GPUs when the completion window is shorter.

GPU memory fit:
Needed to prevent recommending a GPU that cannot hold model weights, KV cache, and runtime reserve.

GPU quantity:
Needed to satisfy memory, throughput, or training constraints.

Server quantity:
Needed because GPUs are purchased and deployed in whole server configurations.

HA:
Needed to preserve service during maintenance or component failure, subject to actual architecture.

DR:
Needed to estimate recovery-environment compute and data protection.

Storage:
Needed for knowledge content, embeddings/indexes, training data, logs, snapshots, backup, and replication.

Network:
Needed for client traffic and multi-GPU/multi-node communication.

Development and Production separation:
Needed because Development should not automatically be sized as full Production, while Production needs availability, DR, and peak capacity.

Cluster consolidation:
Needed because multiple compatible workloads may share a server or cluster, preventing duplicated infrastructure.

Performance and Price options:
Needed to provide a technically compliant decision range rather than one unexplained recommendation.

Financials:
Needed to translate architecture quantities into a planning budget and identify cost drivers.

Traceability:
Needed to explain why each result exists and what changes when an input or override changes.

=================================================================
5. CURRENT MISSING PARTS AND KNOWN DEFECTS
=================================================================

CRITICAL
1. Language Class formula does not differentiate language choices and currently returns Regional in both branches.
2. Cloud BOM is not populated with exact provider/region/SKU prices and is not procurement ready.
3. Hardware prices and performance values are static planning baselines, not current validated evidence.
4. Development factor, coincidence factor, and target utilization are hardcoded planning values.
5. Exact procurement part numbers and full OEM-configured server details are incomplete.
6. Measured model/GPU/runtime benchmark matching is incomplete.

HIGH PRIORITY
7. Explicit latency inputs and outputs are incomplete: TTFT, inter-token latency, P95/P99 response time, queueing, and sustained concurrency.
8. RTO and RPO are not direct inputs.
9. HA uses broad multiplicative factors rather than explicit failure-domain/N+1 design.
10. DR compute and storage design is not region/site/topology specific.
11. Workload peak-overlap scheduling is not captured; coincidence is fixed at 1.0.
12. GPU partitioning/MIG/time-slicing is not calculated from supported profiles.
13. Security zones, regulatory isolation, data residency, tenancy, and runtime compatibility are not part of the cluster key.
14. File type does not fully drive OCR/parser/ingestion compute and storage.
15. Prompt caching does not use cache-hit rate or provider-specific cached-token economics.
16. Executive workload allocation is not dynamically expanded for all active workloads.
17. Traceability version metadata is inconsistent and still contains older version labels.

MEDIUM PRIORITY
18. Currency conversion and tax are missing.
19. Facilities cost, rack space, power, cooling, PUE, installation, shipping, and professional services are incomplete.
20. Licensing is not fully vendor-metric aware.
21. Storage IOPS, throughput, latency, data reduction, and detailed retention classes are not modelled.
22. Network topology, oversubscription, switch port count, optics, cables, and redundancy require design-level logic.
23. Carbon/energy reporting is absent.
24. Sensitivity analysis and uncertainty ranges are absent.
25. Catalog change control and approval workflow are not implemented.
26. No automated import from model cards, OEM catalogs, benchmark repositories, or cloud price APIs.
27. No saved scenario history or version comparison.
28. No role-based protection beyond spreadsheet locking conventions.
29. The hidden legacy financial sheet creates duplicate maintenance surface.

=================================================================
6. FUTURE UPDATE ROADMAP
=================================================================

Release 8.4: Correctness and clarity
1. Correct language classification.
2. Update all version labels to 8.4.
3. Add explicit workload growth and data growth input fields with 20% defaults.
4. Move Development factor and target utilization to governed inputs or policy cells.
5. Add explicit concurrency/peak overlap schedule and evidence status.
6. Expand allocation output dynamically for every active workload.
7. Add tests proving every material input changes the intended downstream outputs.
8. Remove obsolete hidden or duplicate calculation layers where safe.

Release 8.5: Benchmark and performance governance
1. Build matched benchmark keys: model + revision + precision + GPU + runtime + tensor parallel + batch + input length + output length.
2. Add TTFT, inter-token latency, P50/P95/P99, queue depth, and utilization limits.
3. Add measured MFU for training.
4. Add confidence level and evidence expiry date.
5. Prevent recommendations where matched evidence is missing unless clearly marked approximate.

Release 8.6: Procurement-complete on-premises BOM
1. Add exact CPU, DIMM, disk, RAID/HBA, NIC/DPU, optics, cables, PSU, rack, PDU, and support SKUs.
2. Add OEM configuration validation.
3. Add node counts by failure domain.
4. Add switch topology and port-map calculations.
5. Add storage performance and data-protection configuration.
6. Add implementation, shipping, tax, support, and professional services.
7. Separate recurring and non-recurring costs.

Release 8.7: Cloud production path
1. Add provider, region, availability zone, exact GPU instance/VM shape, and pricing model inputs.
2. Populate AWS, Azure, GCP, OCI, and Yotta records with dated evidence.
3. Add on-demand, reserved/committed, savings-plan, and spot/preemptible comparisons where appropriate.
4. Add block/file/object storage performance tiers.
5. Add managed Kubernetes, load balancer, monitoring, backup, NAT/private connectivity, inter-zone transfer, and egress.
6. Add DR region and cross-region replication.
7. Add cloud monthly, annual, and planning-period TCO.

Release 8.8: Advanced cluster scheduling
1. Add security and regulatory isolation dimensions.
2. Add runtime/software compatibility keys.
3. Add MIG profile support where hardware supports it.
4. Add whole-GPU, MIG, time-slicing, and dedicated-node allocation policies.
5. Add scheduled training windows and peak-overlap calculations.
6. Aggregate demand before rounding where safe.
7. Add fragmentation and scheduler-efficiency factors.

Release 9.0: Application platform
1. Move governed catalogs and formulas into a maintainable database/service.
2. Provide a web or Python application for unlimited workloads and scenario versioning.
3. Keep Excel as an export and review artifact.
4. Add role-based access, approvals, evidence snapshots, audit log, release management, and automated regression tests.
5. Add API integration for cloud prices, vendor catalogs, and benchmark repositories.

=================================================================
7. TESTING REQUIREMENTS FOR EVERY RELEASE
=================================================================

Test cycle 1: Formula integrity
- No circular references.
- No #VALUE!, #REF!, #DIV/0!, #N/A, #NAME?, or #NUM! in expected use.
- No unintended implicit-intersection @ behavior.
- No array formula dependence where standard formulas are required.

Test cycle 2: Input and mapping validation
- Every dropdown works.
- Complexity mix must total 100%.
- Active workloads require all mandatory fields.
- Unmapped use cases return REVIEW/UNMAPPED.
- Model override requires reason.

Test cycle 3: Sensitivity and causality
For each material input, change one value and verify the expected downstream impact:
- Complexity mix changes tokens and capacity.
- Demand changes RPS/TPS and GPU/server quantity.
- Planning period changes growth and storage.
- Availability changes Production reserve.
- DR changes DR capacity.
- Model override changes memory, GPU fit, BOM, and cost.
- Training tokens, epochs, or deadline changes training GPU count.
- Knowledge content changes storage but not model parameter size.
- Vendor preference changes eligible options without random selection.

Test cycle 4: Scenario and consolidation
- Development and Production remain separate.
- Performance-Optimized and Price-Optimized remain distinct where catalog evidence supports different choices.
- Shared components are counted once.
- Compatible workloads consolidate.
- Incompatible workloads remain separate.
- Server and GPU quantities are whole deployable units.
- HA and DR are not double-counted.

Test cycle 5: Procurement and financial validation
- Every BOM quantity traces to capacity.
- Every unit price has source and date or is marked approximate/incomplete.
- Cloud records without exact price remain Not Procurement Ready.
- Total equals the sum of compute, storage, network, platform/software, HA, and DR according to defined financial scope.
- Currency and planning period are displayed correctly.

Additional regression tests:
- Validate at least 10 diverse active workloads.
- Validate inference, RAG, multimodal, fine-tuning, and training.
- Validate all three GPU vendors and at least three server vendors where catalog coverage exists.
- Validate Standard, High Availability, and Fault Tolerant.
- Validate None, Cold, Warm, and Hot DR.
- Validate 1-year, 3-year, and 5-year planning periods.
- Validate On-Premises, Cloud, and Hybrid paths.

=================================================================
8. OPERATING INSTRUCTIONS
=================================================================

1. Open Sheet 1 Executive Inputs.
2. Select Deployment Type, Availability, DR, Planning Period, Currency, and GPU Vendor Preference.
3. Complete one row per workload.
4. Ensure each active row has Mapping Status = MAPPED and Input Status = PASS.
5. Ensure complexity percentages total 100%.
6. Set Development Required and Production Required independently.
7. Review Sheet 2 for model, precision, token, context, and memory status.
8. Review Sheet 3 for request rate, TPS, training, GPU, server, storage, and network status.
9. Review Sheet 4 when investigating why an option was selected or rejected.
10. Review Sheet 7A to confirm workload-to-pool allocation.
11. Review Sheet 7B for detailed procurement-oriented BOM structure.
12. Review Sheet 8 for executive totals and decision comparison.
13. Review Sheet 9 for traceability.
14. Review Sheet 10 for formula definitions, policies, catalogs, and tests.
15. Do not approve procurement if any relevant output says REVIEW, INCOMPLETE, quote required, or not procurement ready.

=================================================================
9. CHANGE MANAGEMENT RULES
=================================================================

1. Never change a planning constant without recording owner, reason, evidence, effective date, and test result.
2. Never add a model without model-card evidence and architecture fields.
3. Never add a hardware option without a supported complete server configuration.
4. Never add a benchmark value without model, precision, runtime, sequence-length, batch, and hardware metadata.
5. Never add a price without currency, region, date, unit, source, and validity period.
6. Never change a selection rule without updating Formula ID documentation and regression tests.
7. Never hide an unresolved error with IFERROR unless the resulting status clearly indicates REVIEW or INCOMPLETE.
8. Never allow an inactive workload to contribute to capacity or cost.
9. Never double-count shared components.
10. Never present a placeholder cloud value as a real quote.
11. Maintain backward-compatible version notes and a release log.

=================================================================
10. FINAL ASSESSMENT
=================================================================

What v8.3 does well:
- Provides a single executive input sheet.
- Supports up to 500 workload rows.
- Uses a governed use-case mapping structure.
- Separates token, memory, capacity, catalog, option, cluster, BOM, output, traceability, and test layers.
- Evaluates multiple hardware options rather than forcing one GPU for every workload.
- Separates Development and Production.
- Produces Performance-Optimized and Price-Optimized choices.
- Consolidates workloads into node pools.
- Creates a detailed procurement-oriented BOM structure.
- Keeps formula IDs and technical logic out of the executive view.
- Marks cloud records as incomplete when live data is unavailable.

What prevents v8.3 from being fully production/procurement ready:
- Known language-classification defect.
- Static benchmark and price baselines.
- Incomplete cloud data.
- Incomplete exact server part-number configuration.
- Hardcoded Development, concurrency, and utilization policies.
- Incomplete latency, scheduling, security, topology, RTO/RPO, facilities, and licensing models.
- Inconsistent version metadata in traceability.
- Need for broader automated regression and measured benchmark validation.

Recommended status:
ARCHITECTURE AND COMMERCIAL PLANNING PROTOTYPE.
NOT YET A FINAL PROCUREMENT OR CAPACITY GUARANTEE.

=================================================================
11. FORMULA GLOSSARY
=================================================================

This section translates the workbook's formula IDs, variables, units, operators, and calculation concepts into plain language. The symbolic formulas below describe the intended business logic. The exact Excel cell formulas are maintained in Sheets 2, 3, 4, 7A, 7B, 8, 9, and 10.

11.1 COMMON MATHEMATICAL TERMS
------------------------------

CEILING(value, 1)
Rounds a calculated requirement upward to the next whole unit.
Why used: GPUs, servers, switches, and storage units must be purchased as deployable whole quantities.
Example: 2.1 required servers becomes 3 servers.

MAX(a, b, c)
Returns the largest binding requirement.
Why used: Hardware must satisfy memory, throughput, and training-deadline constraints simultaneously.

MIN(a, b)
Returns the lower allowed value.
Why used: Prevents a calculated context, batch, or capacity value from exceeding a supported limit.

SUMPRODUCT(values, weights)
Multiplies each value by its associated percentage or weight, then adds the results.
Why used: Calculates weighted token demand from the Simple, Medium, and Complex usage mix.

INDEX/MATCH or governed-key lookup
Finds the matching catalog record for a composite business or technical key.
Why used: Maintains deterministic mapping without random selection.

IF/IFS
Applies a governed business rule according to input values or status.

COUNTIFS/SUMIFS
Counts or totals records that match environment, scenario, node pool, category, or other defined criteria.

IFERROR
Returns a controlled status or blank when a lookup cannot be completed.
Governance warning: IFERROR must not hide an unresolved engineering issue. Missing mappings should return REVIEW, UNMAPPED, or INCOMPLETE where material.

Growth compounding
(1 + annual growth rate)^planning years
Why used: Sizes for the selected planning horizon rather than only present demand.

GiB
Gibibyte, 2^30 bytes. Used for model and accelerator-memory calculations.

GB
Gigabyte, normally 10^9 bytes. Used for business data-volume inputs unless otherwise specified.

TB
Terabyte. Storage outputs should state whether decimal TB or binary TiB is used. The current workbook primarily displays TB but requires future unit normalization.

TPS
Tokens per second. Separate input TPS and output TPS are calculated because prompt processing and token generation have different performance characteristics.

RPS
Requests per second. Represents the technical request rate after applying demand conversion, workload share, model calls, and growth where applicable.

PFLOPS
Peta floating-point operations per second. Used as a planning measure for training compute.

TTFT
Time to first token. Not fully implemented in v8.3 and required in a future performance model.

ITL
Inter-token latency. Not fully implemented in v8.3 and required in a future performance model.

RTO
Recovery Time Objective. Not currently a direct workbook input.

RPO
Recovery Point Objective. Not currently a direct workbook input.

11.2 TOKEN FORMULAS
-------------------

TOK-101: Weighted Input Tokens
Formula:
Weighted Input Tokens =
(Simple Share x Simple Input Tokens)
+ (Medium Share x Medium Input Tokens)
+ (Complex Share x Complex Input Tokens)

Inputs:
- Simple %, Medium %, Complex %
- Governed input-token tiers for the mapped use case

Output:
Average input tokens per model call or request profile.

Why calculated:
Input tokens affect context-window eligibility, prefill throughput, request capacity, KV cache, and cost.

Required validation:
Simple % + Medium % + Complex % must equal 100%.

TOK-102: Weighted Output Tokens
Formula:
Weighted Output Tokens =
(Simple Share x Simple Output Tokens)
+ (Medium Share x Medium Output Tokens)
+ (Complex Share x Complex Output Tokens)

Inputs:
- Usage mix
- Governed output-token tiers
- Expected answer type

Output:
Average generated tokens per model call.

Why calculated:
Output tokens affect decode throughput, response time, concurrent capacity, and cost.

Tool Tokens
Formula concept:
Tool Tokens = Governed Tool Token Allowance x Tool/Agent Usage Rule

Why calculated:
Tool calls and intermediate agent steps add model context and may create additional model calls.

History Tokens
Formula concept:
History Tokens = Governed History Allowance for selected Conversation History profile

Why calculated:
Retained conversation history consumes context and KV-cache memory.

Retrieved Tokens
Formula concept:
Retrieved Tokens = Governed Retrieval Allowance based on Supporting Context, use case, and knowledge profile

Why calculated:
RAG prompts include retrieved chunks in addition to the user's question.

Total Context
Formula concept:
Total Context = Weighted Input + Tool Tokens + History Tokens + Retrieved Tokens + System/Control Allowance

Why calculated:
The final model must support the total context, not only the user's visible request.

Model Calls per Transaction impact
Formula concept:
Effective Model Calls = Business Transactions x Model Calls per Transaction

Why calculated:
A single user action may invoke planning, retrieval, tool execution, validation, and answer-generation calls.

11.3 MODEL AND PRECISION FORMULAS
---------------------------------

Recommended Model
Rule:
Select the governed model mapped to the workload's model tier, modality, language class, and supported task profile.

Final Model
Rule:
If a valid Model Override exists, use the override; otherwise use the Recommended Model.

Override requirement:
The override reason must be recorded, and all downstream model architecture, precision, memory, capacity, hardware, HA, DR, BOM, and financial calculations must recalculate.

Context Eligibility
Formula concept:
Model Eligible = Total Context <= Model Context Limit

Why calculated:
A model that cannot accept the complete working context is not eligible even if model weights fit on the GPU.

Precision
Meaning:
Numerical representation used for model weights and possibly computation, such as FP16, BF16, FP8, INT8, or INT4 where supported.

Bytes per Parameter planning examples:
- FP32 approximately 4 bytes
- FP16/BF16 approximately 2 bytes
- INT8 approximately 1 byte
- INT4 approximately 0.5 byte before metadata and implementation overhead

Governance warning:
The exact memory benefit and performance effect depend on quantization format, scales, metadata, kernels, runtime, model architecture, and quality acceptance. The workbook's bytes-per-parameter value is a planning abstraction.

11.4 MEMORY FORMULAS
--------------------

MEM-101: Model Weight Memory
Formula:
Model Weight GiB = Parameters in Billions x Bytes per Parameter x 1,000,000,000 / 1,073,741,824

Inputs:
- Model parameter count
- Selected precision

Output:
Approximate model-weight memory in GiB.

Why calculated:
The model weights must fit in usable accelerator memory.

Exclusions:
KV cache, activations, runtime workspace, communication buffers, fragmentation, and framework overhead.

MEM-102: KV-Cache Memory
Planning formula:
KV Cache GiB =
2 x Layers x Hidden Size x Active Context Tokens x Batch/Concurrency Proxy x KV Bytes
/ 1,073,741,824

Meaning of factor 2:
Represents key and value tensors.

Why calculated:
Inference memory grows with concurrent retained context, not only model size.

Limitations:
Exact KV cache depends on attention architecture, number of KV heads, grouped-query attention, multi-query attention, cache data type, paged allocation, prefix sharing, and runtime implementation.

MEM-103: Runtime Memory
Formula:
Runtime Memory = (Model Weights + KV Cache) x (1 + Runtime Overhead + Safety Margin)

Current assumptions:
- Runtime overhead = 10%
- Memory safety margin = 15%

Why calculated:
Prevents sizing to theoretical memory capacity with no space for runtime operation.

Memory GPUs
Formula:
Memory GPUs = CEILING(Runtime Memory / Usable Memory per GPU, 1)

Usable Memory per GPU
Formula:
Usable Memory = Advertised GPU Memory x Usable Percentage

Current planning assumption:
Usable percentage is generally catalogued around 90%, depending on option.

Why calculated:
Some accelerator memory must remain available for drivers, runtime, workspace, allocator fragmentation, and operational reserve.

11.5 DEMAND AND CAPACITY FORMULAS
---------------------------------

CAP-101: Planning Request Rate
General formula:
Planning RPS = Demand Value x Workload Share x Demand-Unit Conversion x Growth Factor x Model Calls per Transaction

The exact conversion depends on Demand Unit.

Examples of conversion logic:
- Events per second can map directly to event requests per second.
- Transactions per hour require division by 3,600 and an activity/profile rule.
- Pages per hour require division by 3,600 and may require pages-per-request assumptions.
- Concurrent sessions require a governed requests-per-active-session rate.
- Camera streams require frame/clip sampling and inference-frequency rules.
- Audio hours/day require segmentation, processing-window, and operating-hour rules.
- Training tokens are handled through training compute, not ordinary interactive RPS.

Why calculated:
Business volumes must be translated into technical load before GPU sizing.

Growth Factor
Formula:
Growth Factor = (1 + Annual Workload Growth)^Planning Years

Current assumption:
Annual workload growth = 20% unless governed values are updated.

Input TPS
Formula:
Input TPS = Planning RPS x Weighted Input Tokens

If Model Calls per Transaction is not already included in Planning RPS, multiply by Model Calls per Transaction once. It must not be applied twice.

Output TPS
Formula:
Output TPS = Planning RPS x Weighted Output Tokens

CAP-102: Throughput GPUs
Formula:
Input GPUs = CEILING(Input TPS / Matched Input TPS per GPU, 1)

Output GPUs = CEILING(Output TPS / Matched Output TPS per GPU, 1)

Throughput GPUs = MAX(Input GPUs, Output GPUs)

Why calculated:
The larger of prefill or decode demand governs the throughput requirement.

CAP-103: Base GPUs
Formula:
Base GPUs = MAX(Memory GPUs, Throughput GPUs, Training GPUs)

Why calculated:
All constraints must pass simultaneously.

Base Servers
Formula:
Base Servers = CEILING(Base GPUs / GPUs per Server, 1)

Deployable GPUs
Formula:
Deployable GPUs = Base Servers x GPUs per Server

Why deployable GPUs may exceed Base GPUs:
Servers contain fixed accelerator counts, so physical procurement is rounded to complete server configurations.

11.6 TRAINING AND FINE-TUNING FORMULAS
--------------------------------------

TRN-101: Dense Transformer Training Compute
Formula:
Training FLOPs = 6 x Model Parameters x Training Tokens x Epochs

Unit handling:
Model parameters and training tokens must be converted from billions to absolute counts before applying the equation.

Why calculated:
Provides an order-of-magnitude planning estimate for dense transformer training.

Limitations:
Not universally valid for every architecture, sparse mixture-of-experts utilization pattern, multimodal pipeline, optimizer, sequence length, activation checkpointing, or fine-tuning method.

TRN-102: Training GPU Quantity
Formula:
Training GPUs = CEILING(
Training FLOPs /
(Effective FLOP/s per GPU x Completion Target Seconds),
1)

Completion Target Seconds = Completion Target Hours x 3,600

Effective FLOP/s should include measured utilization or MFU.

Why calculated:
A shorter completion target requires more aggregate compute.

Future requirement:
Separate full training, continued pretraining, full fine-tuning, LoRA/QLoRA, embedding training, and multimodal training rather than using one broad formula path.

11.7 AVAILABILITY AND DISASTER-RECOVERY FORMULAS
------------------------------------------------

HA-101: Production Servers
Current formula:
Production Servers = CEILING(Base Servers x HA Factor, 1)

Current HA factors:
- Standard = 1.00
- High Availability = 1.25
- Fault Tolerant = 2.00

Why calculated:
Adds production reserve for maintenance or component failure.

Critical assumption:
The factors are planning policies. They do not prove N+1, N+2, quorum, failure-domain, rack, power, network, site, or application-level availability.

Preferred future formula:
Production Nodes = Required Active Nodes + Explicit Failure Reserve by Node Pool and Failure Domain

DR-101: DR Servers
Current formula:
DR Servers = CEILING(Production Servers x DR Active Fraction, 1)

Current DR fractions:
- None = 0.00
- Cold = 0.00 active compute
- Warm = 0.50
- Hot = 1.00

Why calculated:
Estimates active recovery-environment compute.

Critical assumption:
Cold DR's zero active compute does not mean zero DR cost. Protected data, object storage, backups, replication, infrastructure-as-code, support, and recovery testing may still be required.

Total Servers
Formula:
Total Servers = Production Servers + DR Servers

Governance warning:
HA and DR must be applied once at the correct consolidated pool/failure-domain level. Applying both at workload level and again at cluster BOM level can double-count capacity.

11.8 STORAGE FORMULAS
---------------------

STO-101: Primary Storage
Conceptual formula:
Primary Storage =
(Content Data
+ Vector/Index Expansion
+ Training/Fine-Tuning Data
+ Logs and Operational Data)
x Data Growth Factor
x Replication/Protection Factor

Data Growth Factor
Formula:
(1 + Annual Data Growth)^Planning Years

Current annual data-growth assumption:
20%.

Current replication assumption:
2x.

Knowledge Content Tier fallbacks currently used in planning logic:
- Small = approximately 50 GB
- Medium = approximately 250 GB
- Large = approximately 1,000 GB
- Enterprise = approximately 5,000 GB

Why calculated:
Provides a fallback when direct Knowledge Content GB is unavailable.

Governance warning:
Tier values are approximations and should never replace measured content inventory where available.

Vector/Index Expansion
Meaning:
Additional storage for embeddings, metadata, chunk text, index structures, replicas, and engine overhead.

Current limitation:
The exact expansion factor is not exposed as a governed input and must be validated for the selected embedding dimension, data type, metadata volume, index type, and database.

Retention
Meaning:
Number of days protected or operational data is retained.

Current limitation:
The workbook does not fully separate knowledge content, logs, prompts, responses, checkpoints, snapshots, backup, and audit data into independent retention classes.

Storage Units
Formula concept:
Storage Units = CEILING(Required Storage / Capacity per Storage Unit, 1)

Why calculated:
Storage appliances or cloud tiers must be purchased in deployable quantities.

11.9 NETWORK FORMULAS
---------------------

NET-101: North-South Bandwidth
Formula:
North-South Gbps =
RPS x (Request Payload KB + Response Payload KB) x 8
/ 1,000,000
x Network Headroom

Current network-headroom assumption:
1.3x.

Why calculated:
Estimates external application and client traffic.

Limitation:
Does not calculate east-west model-parallel, tensor-parallel, pipeline-parallel, data-parallel, storage, checkpoint, replication, or collective communication traffic.

NET-102: Fabric Tier
Rule concept:
Select 100/200/400/800 GbE or equivalent fabric according to workload mode, node count, GPU count, and communication requirement.

Current implementation:
Uses broad workload-mode and deployed-GPU rules.

Future requirement:
Calculate fabric from parallelism strategy, topology, oversubscription, switch radix, port count, link redundancy, optics, cable type, and validated OEM design.

Switch Quantity
Planning formula concept:
Switch Quantity = MAX(Redundancy Minimum, CEILING(Connected Server Ports / Usable Ports per Switch, 1))

Current limitation:
The shared BOM uses a broad planning rule rather than a complete topology and port map.

Optics and Cables
Planning formula concept:
Optic/Cable Sets = Connected High-Speed Server Ports plus inter-switch links and redundancy

Current limitation:
Inter-switch, storage, management, spare, and cable-length requirements are not fully modelled.

11.10 HARDWARE SELECTION FORMULAS
---------------------------------

Mode Compatible
Rule:
The workload mode must appear in the hardware option's supported modes.

Vendor Compatible
Rule:
Preferred GPU Vendor = No Preference OR Preferred GPU Vendor = Option GPU Vendor

Lifecycle Eligible
Rule:
Hardware lifecycle status must equal the governed eligible state, currently GA.

Performance Eligible
Rule concept:
Mode Compatible AND Vendor Compatible AND Lifecycle Eligible AND Memory Pass AND Capacity Pass AND Deployability Pass

Price Eligible
Rule concept:
Uses the same mandatory eligibility constraints as Performance Eligible.

SEL-101: Performance-Optimized Option
Rule:
Among eligible options, select the highest governed benchmark/performance score. Use lower deployable cost only as a tie-break where defined.

SEL-102: Price-Optimized Option
Rule:
Among eligible options, select the lowest deployable cost. Use higher performance only as a tie-break where defined.

No eligible option
Required result:
REVIEW, not a random fallback.

11.11 DEVELOPMENT AND CLUSTER FORMULAS
--------------------------------------

Development Base GPUs
Current formula:
Development Base GPUs = MAX(1, CEILING(Selected Base GPUs x 15%, 1))

Why calculated:
Creates a smaller Development environment rather than copying full Production demand.

Critical assumption:
15% is a static planning factor. Development demand should eventually be based on developer count, test concurrency, scheduled fine-tuning, model count, data subset, and required completion windows.

Production Base GPUs
Current formula:
Production Base GPUs = CEILING(Selected Base GPUs x 100%, 1)

Coincidence Factor
Current value:
1.00.

Meaning:
The proportion of a workload's calculated peak assumed to overlap with peaks from other workloads.

Examples:
- 1.00 means full overlap.
- 0.50 means half of the workload peak contributes to the shared simultaneous peak.

Governance warning:
Coincidence must be supported by workload schedules or telemetry. It must not be guessed solely to reduce BOM quantity.

Concurrent GPU Demand
Formula:
Concurrent GPU Demand = Workload Base GPUs x Coincidence Factor

Target Utilization
Current value:
0.75 or 75%.

Meaning:
Maximum planned sustained pool utilization before additional capacity is added.

Allocated Pool GPUs
Current formula:
Allocated Pool GPUs = CEILING(Concurrent GPU Demand / Target Utilization, 1)

Important design improvement:
In a fully consolidated design, compatible workload demand should normally be summed at pool level and then divided by target utilization before final rounding. Rounding each workload first can overstate capacity.

Pool Key
Current concept:
Environment + Node Pool + Scenario + Selected Option

Why calculated:
Only compatible workloads should share a pool.

Future Pool Key dimensions:
- Environment
- Workload class
- GPU vendor and architecture
- Server platform
- Precision
- Runtime and version
- Modality
- Security zone
- Data residency
- Availability class
- DR class
- Network/fabric requirement
- Tenancy/isolation policy
- Scheduler and GPU-sharing method

Node Pool Rules
- General-Inference: ordinary compatible inference/RAG workloads.
- Large-Model-Inference: large-model workloads crossing the governed model-tier threshold.
- Multimodal-Vision: multimodal or vision workloads.
- Training-FineTune: training and fine-tuning workloads.

11.12 BOM AND FINANCIAL FORMULAS
--------------------------------

BOM-101: Extended Cost
Formula:
Extended Cost = Quantity x Unit Price

Why calculated:
Converts engineering quantities into planning cost.

Configured Server Price
Current concept:
Server Base Price + GPU Unit Price x GPUs per Server, or a stored configured planning price.

Governance warning:
A planning price is not an OEM quotation and may exclude CPUs, memory, disks, networking, support, software, freight, tax, installation, and services.

On-Premises Compute Total
Formula:
Sum of Extended Price for compute-node BOM lines matching Environment and Sizing Option.

Shared Infrastructure Total
Formula:
Sum of storage, backup, network, management, platform, monitoring, and software lines matching Environment and Sizing Option.

Total On-Premises CAPEX
Formula:
Compute + Storage and Backup + Network + Platform and Software

Current scope warning:
The displayed total may not include all recurring subscriptions, support renewals, implementation, facilities, tax, freight, financing, and operational labor.

Cloud Monthly Cost
General formula:
For compute:
Instance Quantity x Hours per Month x Hourly Unit Price

For storage:
TB-Month or GB-Month x Unit Price

For data transfer:
Transfer Quantity x Unit Price

For managed services:
Applicable capacity, operation, request, or subscription quantity x Unit Price

Cloud Planning-Period Cost
Current formula concept:
Monthly Cost x 12 x Planning Years

Future requirement:
Include price escalation, commitment terms, reserved discounts, utilization schedules, support, currency, taxes, and service-specific billing dimensions.

BOM-201: Physical Procurement BOM
Rule:
Translate consolidated pool quantities into complete server, storage, network, software, support, HA, and DR line items.

CLOUD-201: Cloud Billable BOM
Rule:
Every cloud record requires provider, region, exact SKU/service, billing unit, quantity, unit price, price date, currency, and source before procurement readiness can pass.

11.13 VALIDATION FORMULAS
-------------------------

Complexity Validation
Rule:
ABS(Simple % + Medium % + Complex % - 100%) <= allowed rounding tolerance

Mapping Validation
Rule:
Industry and Use Case must match a governed catalog key.

Override Validation
Rule:
If Model Override is not blank, Override Reason must not be blank.

Inactive-Row Validation
Rule:
Inactive workloads must return blanks or zeros and must not contribute to capacity, BOM, or cost.

Integer Deployment Validation
Rule:
GPU, server, switch, and storage-unit quantities must equal their integer values.

Recommendation Validation
Rule:
Active workloads must not produce REVIEW unless no eligible option exists or evidence is incomplete.

Cloud Readiness Validation
Rule:
If provider, region, exact SKU, unit price, or evidence date is missing, status must be INCOMPLETE or NOT PROCUREMENT READY.

=================================================================
12. ASSUMPTIONS GLOSSARY
=================================================================

This section lists explicit and implicit assumptions used by the workbook. Each assumption must be treated as a governed planning input, not as a universal industry constant.

12.1 GENERAL GOVERNANCE ASSUMPTIONS
-----------------------------------

Deterministic logic
Assumption: The same valid inputs and catalog version produce the same output.
Required control: Catalogs and formulas must be versioned.

Planning baseline
Assumption: Static values may be used for preliminary planning when live measured values are unavailable.
Required control: Every approximate value must be labelled and must not be represented as measured evidence.

No random fallback
Assumption: Missing eligibility or evidence results in REVIEW/INCOMPLETE rather than a random recommendation.

Single currency
Assumption: Financial values are displayed in USD.
Missing: Exchange-rate date, conversion logic, and local tax treatment.

Planning period
Assumption: Growth compounds over 1, 3, or 5 years.
Missing: Mid-period purchases, phased rollout, refresh cycles, and decommissioning.

12.2 WORKLOAD ASSUMPTIONS
-------------------------

Workload independence
Assumption: Each workload can first be sized independently before compatible consolidation.
Risk: Shared prompts, shared models, common caches, and common services may create additional efficiencies or dependencies.

Workload Share
Assumption: Provided percentages accurately distribute shared business demand.
Risk: Incorrect sharing can duplicate or understate demand.

Complexity mix
Assumption: Simple, Medium, and Complex percentages represent the expected production mix.
Risk: Average mix does not protect against P95/P99 tail demand.

Typical request profile
Assumption: Governed token tiers reasonably approximate user requests.
Risk: Actual tokenizer results can differ by language, file extraction, prompting style, and model tokenizer.

Model calls
Assumption: Model Calls per Transaction represents all calls created by the workflow.
Risk: Retries, guardrails, routing, summarization, tool loops, and fallback models may add calls.

Prompt caching
Assumption: A Yes/No flag is sufficient for initial eligibility.
Missing: Cacheable-prefix percentage, cache-hit rate, eviction, tenant isolation, and provider-specific pricing.

12.3 LANGUAGE AND MODALITY ASSUMPTIONS
--------------------------------------

Language coverage
Assumption: Language class can be mapped to governed model eligibility and token profiles.
Known defect: v8.3 currently maps all language selections to Regional in Sheet 2.

Multilingual tokenization
Assumption: Governed token tiers approximate language effects.
Missing: Language-specific tokenizer measurements and output-quality minimums.

File types
Assumption: File Types indicates content modality.
Missing: OCR pages, image resolution, video frame rate, audio sampling, parser throughput, ingestion concurrency, and data-expansion factors.

12.4 MODEL ASSUMPTIONS
----------------------

Governed model catalog
Assumption: The catalog contains suitable models for supported use cases.
Risk: Catalog coverage may be incomplete or obsolete.

Model parameters
Assumption: Parameter count is sufficient for weight-memory planning.
Risk: Expert routing, multimodal encoders, adapters, embeddings, draft models, and speculative decoding may add memory.

Context limit
Assumption: Published context limit is usable.
Risk: Serving implementations may reserve tokens or have lower supported limits.

Precision compatibility
Assumption: Selected precision is supported by model, runtime, and hardware.
Risk: Quality loss or unsupported kernels can invalidate the option.

Performance precision
Assumption: The performance scenario uses the precision expected to maximize qualified performance while meeting quality requirements.

Price precision
Assumption: The price scenario may use a lower-memory compatible precision to reduce cost.

Quality acceptance
Assumption: Precision changes are acceptable when model compatibility indicates support.
Missing: Task-specific quality benchmarks and customer acceptance thresholds.

12.5 MEMORY ASSUMPTIONS
-----------------------

Weight memory
Assumption: Parameters x bytes per parameter approximates stored weights.
Missing: Quantization metadata and format overhead.

KV cache
Assumption: The generic key/value formula approximates cache demand.
Missing: Exact KV-head architecture, cache block allocation, prefix reuse, and runtime implementation.

Runtime overhead
Current assumption: 10%.
Meaning: Reserve for runtime workspace and framework overhead.
Required future evidence: Measured peak memory on the target serving stack.

Memory safety margin
Current assumption: 15%.
Meaning: Additional reserve against variation and fragmentation.
Required future evidence: Operational policy based on measured workloads.

Usable GPU memory
Assumption: Catalog Usable % accurately represents allocatable memory.
Risk: Driver, ECC, runtime, CUDA/ROCm, graph capture, workspace, and fragmentation vary.

Batch proxy
Assumption: A simplified batch/concurrency proxy represents active KV-cache demand.
Missing: Continuous batching, max batched tokens, queueing, and per-replica scheduler behavior.

12.6 INFERENCE PERFORMANCE ASSUMPTIONS
--------------------------------------

Static TPS
Assumption: Catalog input and output TPS per GPU are suitable planning baselines.
Risk: TPS varies materially by model, precision, runtime, batch, sequence length, tensor parallelism, and latency target.

Average demand
Assumption: Weighted-average tokens and planning RPS are sufficient for preliminary sizing.
Risk: Bursts and tail latency require percentile and queueing analysis.

Target utilization
Current assumption: 75% at the consolidated pool level.
Meaning: 25% operational headroom before additional capacity.
Risk: Correct utilization depends on workload shape, SLA, scheduler, and model-loading fragmentation.

Network headroom
Current assumption: 1.3x or 30%.
Risk: May be insufficient for bursty, replicated, or collective workloads.

Latency
Assumption: Meeting static throughput targets is a preliminary proxy for capacity.
Missing: Explicit TTFT, ITL, end-to-end response time, P95/P99, and admission-control limits.

12.7 TRAINING ASSUMPTIONS
-------------------------

Dense transformer equation
Assumption: 6 x parameters x tokens x epochs is appropriate for rough planning.
Risk: Not exact for every architecture or fine-tuning method.

Effective PFLOPS
Assumption: Catalog effective PFLOPS represents realized compute.
Missing: Framework, topology, parallelism, communication, sequence length, optimizer, and measured MFU.

Completion target
Assumption: The entire job must finish within the entered hours.
Missing: Checkpoint, evaluation, data loading, preprocessing, and restart overhead.

Training tokens
Assumption: Entered token count reflects tokens processed per epoch.
Risk: Filtering, packing, augmentation, and repetition may change actual processed tokens.

12.8 DEVELOPMENT ASSUMPTIONS
----------------------------

Development factor
Current assumption: 15% of selected base GPU demand.
Minimum: One GPU for an active Development allocation.
Risk: Development may require more or less depending on team size, model count, simultaneous experiments, and fine-tuning schedule.

No automatic Production HA/DR inheritance
Assumption: Development does not automatically require Production availability and DR.
Future need: Allow explicit Development availability, backup, and recovery policies.

Shared Development
Assumption: Compatible workloads may share a Development cluster.
Risk: Conflicting software stacks, security constraints, or experiment isolation may require separate pools.

12.9 PRODUCTION AND CLUSTER ASSUMPTIONS
---------------------------------------

Full Production demand
Assumption: Production uses 100% of calculated base demand before utilization and resilience logic.

Coincidence factor
Current assumption: 1.0, meaning peaks fully overlap.
Effect: Conservative for simultaneous-peak planning.
Future need: Derive from schedules or telemetry.

Compatibility by pool key
Assumption: Environment, node pool, scenario, and selected option are sufficient for initial grouping.
Missing: Security, residency, runtime, precision, tenancy, HA class, and fabric compatibility.

GPU sharing
Assumption: Kubernetes quotas and supported sharing may improve utilization for small workloads.
Missing: MIG profile, time-slicing, memory isolation, quality-of-service, and fragmentation calculations.

Rounding
Assumption: Workload and pool demands can be rounded to whole GPUs/servers.
Risk: Rounding before aggregation may overstate capacity.

12.10 AVAILABILITY ASSUMPTIONS
------------------------------

Standard
Current factor: 1.0.
Assumption: No active capacity reserve.

High Availability
Current factor: 1.25.
Assumption: 25% planning reserve.
Risk: Does not guarantee N+1 after server failure.

Fault Tolerant
Current factor: 2.0.
Assumption: Dual-active planning.
Risk: Actual fault tolerance requires application, data, network, control-plane, and site design.

Failure domains
Assumption: Multiplicative factors approximate resilience.
Missing: Rack, power, network, storage, zone, and site failure-domain placement.

12.11 DR ASSUMPTIONS
--------------------

None
Assumption: No DR compute.
Data protection may still be required by policy.

Cold
Assumption: No active DR compute, recovery from protected data or rebuilt infrastructure.

Warm
Current assumption: 50% active compute.
Risk: May not meet actual RTO without workload prioritization.

Hot
Current assumption: 100% active compute.
Risk: Full hot DR also requires synchronized applications, data, networking, security, and operations.

Storage replication
Assumption: Primary storage replication factor contributes to protection.
Missing: Site/region topology, RPO, replication lag, backup immutability, and restore testing.

12.12 STORAGE ASSUMPTIONS
-------------------------

Annual data growth
Current assumption: 20%.

Primary replication
Current assumption: 2x.

Knowledge tiers
Assumption: Small/Medium/Large/Enterprise fallback sizes approximate content volume.
Risk: Should be replaced by measured inventory.

Vector storage
Assumption: Vector/index overhead can be approximated from content volume.
Missing: Embedding model, dimensions, data type, metadata, index type, replicas, and compression.

Logs
Assumption: Operational logs can be approximated from demand.
Missing: Separate prompt/response, security, audit, metrics, traces, and retention policies.

Backup
Assumption: Backup storage can be related to primary data and DR choice.
Missing: Full/incremental schedule, retention, deduplication, immutable copies, and restore performance.

12.13 NETWORK ASSUMPTIONS
-------------------------

Payload size
Assumption: Request and response payload can be approximated from token demand or governed KB values.
Risk: Multimodal payloads are much larger.

North-south traffic
Assumption: Application traffic can be estimated independently of east-west traffic.

Fabric tiers
Assumption: Broad GPU-count and mode thresholds identify a reasonable fabric class.
Missing: Parallelism-aware bandwidth calculation.

Switch redundancy
Assumption: At least two switches are used where redundancy is required.
Missing: Leaf-spine topology and control-plane/management separation.

12.14 HARDWARE CATALOG ASSUMPTIONS
----------------------------------

Lifecycle
Assumption: GA indicates selectable hardware.
Future need: Add announced, preview, GA, limited availability, end-of-sale, and end-of-support dates.

Configured server
Assumption: The listed server/GPU combination is technically configurable.
Required evidence: OEM configuration guide and quotation.

Performance score
Assumption: A higher catalog score indicates a better Performance-Optimized choice among eligible options.
Risk: Score is not a universal benchmark and must be workload matched.

Server price
Assumption: Static configured price is sufficient for planning comparison.
Risk: Does not equal a current quote.

GPU TDP
Assumption: GPU TDP is informative.
Current limitation: Power and cooling do not materially drive the main financial output.

12.15 CLOUD ASSUMPTIONS
-----------------------

Provider coverage
Assumption: AWS, Azure, GCP, OCI, and Yotta represent the required comparison set.

Ten service categories
Assumption: The configured categories cover the principal billable services.
Risk: Provider-specific services and billing dimensions may differ.

Hours per month
Current planning pattern:
Development may use approximately 160 hours/month; Production may use approximately 730 hours/month.
Risk: Development schedules and Production autoscaling can differ materially.

Zero price
Assumption: Zero represents missing data, not a free service.
Required status: INCOMPLETE or NOT PROCUREMENT READY.

Region
Assumption: A region must be selected before pricing and availability can be trusted.

Discounts
Missing: Reserved instances, savings plans, commitments, enterprise discounts, spot/preemptible risk, and support plans.

Data transfer
Missing: Inter-zone, inter-region, internet egress, private connectivity, NAT, and replication detail.

12.16 FINANCIAL ASSUMPTIONS
---------------------------

CAPEX
Assumption: On-premises initial hardware and selected shared components are treated as CAPEX planning values.

OPEX
Current limitation: Support renewals, software subscriptions, facilities, energy, operations, and labor are incomplete.

Price validity
Assumption: Static prices support comparison only.
Required for procurement: Dated quote, currency, validity period, taxes, freight, and support terms.

Planning-period TCO
Assumption: Monthly cloud cost x 12 x years approximates term cost.
Missing: Escalation, discounting, commitments, growth phasing, and resource refresh.

Primary cost driver
Rule: Largest major cost category in the executive summary.
Limitation: A category can appear dominant because omitted costs are not represented.

12.17 EVIDENCE AND CONFIDENCE ASSUMPTIONS
----------------------------------------

Evidence status
Assumption: Text labels communicate whether a value is measured, sourced, static, approximate, quote required, or incomplete.

Current limitation:
There is no unified numerical confidence score, evidence expiry workflow, or approval owner.

Source URLs
Assumption: Catalog source links provide traceability.
Required improvement: Store source title, publisher, version, publication date, retrieval date, applicable record, and archived evidence snapshot.

12.18 TESTING ASSUMPTIONS
-------------------------

Formula validation
Assumption: Workbook recalculation in a compatible spreadsheet engine produces the intended formulas.
Required: Test in the supported Microsoft Excel version because alternative engines can rewrite or interpret formulas differently.

Sample workloads
Assumption: Sample rows demonstrate core logic.
Required: A formal regression suite must include at least ten diverse workloads and all major branches.

No errors
Assumption: Absence of visible formula errors is necessary but not sufficient.
Required: Also test correctness, causality, sensitivity, eligibility, rounding, and non-duplication.

=================================================================
13. GLOSSARY OF STATUS VALUES
=================================================================

ACTIVE / Yes
The workload participates in calculations.

INACTIVE / No
The workload must not contribute to model, capacity, BOM, or financial totals.

PASS
Mandatory validation or an engineering constraint passed.

FAIL
Mandatory validation failed. The row should not be used for final recommendation.

MAPPED
Industry and use case exist in the governed mapping catalog.

UNMAPPED
No governed mapping exists. The workload requires catalog maintenance or corrected input.

REVIEW
A recommendation or calculation could not be safely finalized and requires engineering review.

PLANNING READY
The structure and planning calculations are available, but current evidence and quotations may still be required.

QUOTE REQUIRED
The technical quantity may be available, but a current supplier quotation is missing.

INCOMPLETE
A material required field, catalog value, evidence item, or price is missing.

NOT PROCUREMENT READY
The output must not be used for purchasing because exact configuration, quantity, price, region, evidence, or approval is missing.

PERFORMANCE-OPTIMIZED
Highest-performing eligible configuration according to the governed performance score and constraints.

PRICE-OPTIMIZED
Lowest-cost eligible deployable configuration that still passes the defined engineering constraints.

=================================================================
14. FORMULA AND ASSUMPTION MAINTENANCE CHECKLIST
=================================================================

Before changing a formula:
1. Identify the Formula ID.
2. Record the business reason.
3. Record the old and new symbolic formula.
4. Identify all dependent cells and sheets.
5. Update evidence and limitations.
6. Add positive, negative, boundary, and inactive-row tests.
7. Run sensitivity tests.
8. Confirm Development and Production behavior.
9. Confirm Performance-Optimized and Price-Optimized behavior.
10. Confirm no shared component is double-counted.
11. Update version metadata and README.

Before changing an assumption:
1. Assign an assumption or policy ID.
2. Record the owner.
3. Record the evidence source.
4. Record the effective date and review date.
5. Record allowed override ranges.
6. Identify affected formulas and outputs.
7. Re-run the five-cycle test suite.
8. Mark any result that still uses stale evidence.

Before adding a catalog record:
1. Validate model/server/cloud identity and version.
2. Validate compatibility.
3. Validate benchmark conditions.
4. Validate source date.
5. Validate lifecycle.
6. Validate price unit and currency.
7. Validate complete procurement configuration where applicable.
8. Add traceability and regression coverage.

=================================================================
15. FINAL DOCUMENT CONTROL NOTE
=================================================================

This README documents the logic observed in AI_Infrastructure_Sizing_v8.3_Clear_Executive_BOM.xlsx as of 18 September 2026. If workbook formulas, assumptions, catalogs, sheet names, or selection rules change, this README must be updated in the same release. The workbook and README should always carry the same version number.

=================================================================
16. SHEET-BY-SHEET USER GUIDE
=================================================================

16.1 RECOMMENDED USER ROLES
---------------------------

Executive or Business Sponsor
Primary sheets: 1 and 8.
Responsibilities: Supply business demand, availability, DR, planning horizon, and environment requirements; compare the Performance-Optimized and Price-Optimized outputs; review readiness and limitations.

AI or Solution Architect
Primary sheets: 1, 2, 3, 4, 7A, 7B, 8, and 9.
Responsibilities: Validate workload mapping, model eligibility, token assumptions, capacity, cluster grouping, BOM configuration, and end-to-end traceability.

Infrastructure Architect
Primary sheets: 3, 4, 5, 7A, and 7B.
Responsibilities: Validate servers, accelerators, CPU/RAM/storage/network configuration, node pools, fabric, HA, DR, and deployability.

Cloud Architect or FinOps Reviewer
Primary sheets: 1, 6, 7B, and 8.
Responsibilities: Populate exact provider/region/SKU prices, validate monthly consumption, and confirm cloud readiness.

Procurement or Commercial Reviewer
Primary sheets: 5, 6, 7B, 8, and 9.
Responsibilities: Replace planning prices with current quotes, confirm exact part numbers, validate commercial scope, and reject incomplete records.

Model or Performance Engineer
Primary sheets: 2, 3, 4, 5, and 10.
Responsibilities: Validate model cards, precision, context, benchmark conditions, memory, throughput, latency, and training performance.

Workbook Maintainer
Primary sheets: All sheets, especially 9 and 10.
Responsibilities: Control formulas, policies, catalogs, evidence, tests, versions, and release notes.

16.2 GENERAL WORKING RULES
--------------------------

1. Enter or change values only in the intended blue input cells on Sheet 1 unless performing controlled catalog maintenance.
2. Do not overwrite formulas on calculation or output sheets.
3. Complete one row for every materially different workload.
4. Use a separate workload row when demand unit, model profile, availability, DR, security boundary, modality, or environment differs.
5. Do not mark a row Active until mandatory inputs are complete.
6. Treat PASS as input validation only, not proof of procurement readiness.
7. Treat REVIEW, UNMAPPED, FAIL, INCOMPLETE, and NOT PROCUREMENT READY as blocking statuses for final approval.
8. After changing a material input, review Sheets 2, 3, 7A, 7B, and 8 to confirm the intended downstream change.
9. Use Sheet 4 to explain why a hardware option passed or failed.
10. Use Sheet 9 to audit the path from inputs to output.
11. Use Sheet 10 to understand formula IDs, policy constants, and automated tests.
12. Save each approved scenario as a separate version. Do not overwrite the only approved baseline.

16.3 SHEET 1 USER GUIDE: EXECUTIVE INPUTS
-----------------------------------------

Purpose
Sheet 1 is the only routine user-input sheet. Sheet 1 captures global planning choices and up to 500 workloads.

Before entering workloads
1. Select Deployment Type.
2. Select Availability Requirement.
3. Select DR Requirement.
4. Select Planning Period.
5. Confirm reporting currency.
6. Select Preferred GPU Vendor or No Preference.

Deployment Type guidance
- On-Premises: Use when the primary target is customer-owned infrastructure.
- Cloud: Use when exact cloud provider, region, service, and pricing will be populated.
- Hybrid: Use when workloads or environments are split across on-premises and cloud.

Availability guidance
- Standard: No active reserve in the current factor model.
- High Availability: Adds a planning reserve, currently 25%.
- Fault Tolerant: Uses a 2x planning factor.
Do not select availability only to increase hardware quantity. Select according to business service requirements and a future failure-domain design.

DR guidance
- None: No active DR compute in the current model.
- Cold: Protected data and rebuild/recovery process; no active DR compute.
- Warm: Partial active DR compute, currently 50%.
- Hot: Full active DR compute, currently 100%.
The desired future workflow should also capture RTO, RPO, recovery priority, DR site/region, and replication method.

How to create a workload
1. Keep the generated Workload ID unique.
2. Select Industry.
3. Select a mapped Use Case.
4. Enter Workload Share if demand is distributed across multiple workloads.
5. Enter Simple, Medium, and Complex percentages so Total equals 100%.
6. Enter the applicable Demand Value and Demand Unit.
7. Select Language Coverage.
8. Enter supported File Types.
9. Select Workload Mode.
10. Complete request-profile inputs.
11. Complete training inputs only for training or fine-tuning workloads.
12. Complete knowledge and retention inputs where applicable.
13. Select Development Required and Production Required independently.
14. Add Workload Notes.
15. Confirm Mapping Status, Input Status, and Active status.

How to select the correct Demand Unit
- Concurrent sessions: Interactive applications with simultaneous active users.
- Events per second: Stream or event-scoring workloads.
- Pages per hour: Document-processing workloads.
- Transactions per hour: Business transactions processed in a defined period.
- Camera streams: Video or frame-based analytics.
- Audio hours/day: Speech and audio processing.
- Training tokens (B): Training or fine-tuning dataset volume.
Never convert units manually to another workload type unless the governed mapping explicitly requires it.

How to use complexity mix
Simple, Medium, and Complex represent usage proportions, not subjective labels on the whole application.
Example:
- 50% simple
- 35% medium
- 15% complex
- Total = 100%
The mix changes weighted input/output tokens and downstream capacity.

When to use Model Override
Use an override only when a business, regulatory, compatibility, licensing, model-quality, or platform requirement justifies it. Always complete Override Reason. Then verify that model architecture, precision, memory, capacity, selected hardware, cluster allocation, BOM, and financial values changed where expected.

Completion criteria for an active row
- Mapping Status = MAPPED.
- Input Status = PASS.
- Active = Yes.
- Complexity Total = 100%.
- Demand value and unit are appropriate.
- Model override has a reason if populated.
- Development and Production flags reflect actual scope.

Common mistakes
- Giving every workload 100% of a common demand total.
- Leaving complexity mix below or above 100%.
- Using concurrent sessions for non-interactive batch processing.
- Entering parameter size in Knowledge Content GB.
- Entering knowledge-base size as Training Tokens.
- Marking both Development and Production without a real requirement.
- Selecting a GPU vendor preference before confirming platform availability.
- Treating inactive rows as deleted records.

16.4 SHEET 2 USER GUIDE: MODEL SELECTION
----------------------------------------

Purpose
Review workload mapping, token calculation, context, model recommendation, final model, precision, and memory.

What the user should review
1. Workload Type matches the selected Use Case.
2. Pool is technically reasonable.
3. Demand Unit matches Sheet 1.
4. Modality matches language and file-type requirements.
5. Weighted Input and Weighted Output are plausible.
6. Total Context is below the model context limit.
7. Recommended Model is not REVIEW.
8. Final Model reflects an override only when entered.
9. Performance and Price precision values are supported.
10. Model Status passes.

How to interpret token columns
Simple/Medium/Complex input and output columns are governed tier values. Weighted values apply the mix from Sheet 1. Tool, history, and retrieved tokens are additional context components.

How to interpret Recommended Model and Final Model
Recommended Model is produced by governed mapping. Final Model is the recommended model unless a valid override is provided.

How to interpret precision
Performance precision supports the Performance-Optimized path. Price precision supports the Price-Optimized path. A lower-memory precision is not valid unless model, runtime, accelerator, and quality requirements allow it.

Blocking conditions
- UNMAPPED workload type.
- Total Context exceeds context limit.
- Missing model architecture data.
- Unsupported precision.
- Final Model shows REVIEW.
- Model Status does not pass.

Known v8.3 issue
Language Class currently does not correctly distinguish language selections. Do not approve language-sensitive model selection until this formula is corrected.

16.5 SHEET 3 USER GUIDE: CAPACITY ENGINE
----------------------------------------

Purpose
Review workload growth, RPS/TPS, training demand, selected options, GPU/server quantities, HA, DR, storage, network, and validation.

What the user should review
1. Growth Factor matches the planning period and governed growth rate.
2. HA Factor matches global or workload override.
3. DR Fraction matches global or workload override.
4. Demand Value and Demand Unit are correct.
5. Planning RPS is plausible.
6. Input TPS and Output TPS are plausible.
7. Training FLOPs and deadline apply only where appropriate.
8. Performance and Price options are populated.
9. GPU and server quantities are integers.
10. Primary Storage reflects knowledge/training inputs, not model parameter size.
11. North-South Gbps and Fabric Tier are plausible.
12. Validation Status passes.

How to compare Performance and Price columns
- Perf columns correspond to the Performance-Optimized eligible option.
- Price columns correspond to the Price-Optimized eligible option.
Compare option, GPU, server, base GPUs, production servers, DR servers, total servers, physical GPUs, and cost.

Important validation questions
- Does doubling demand increase RPS/TPS and eventually capacity?
- Does shortening a training deadline increase required GPUs?
- Does changing DR from None to Hot add DR servers?
- Does changing availability from Standard to High Availability or Fault Tolerant change Production reserve?
- Does increasing knowledge content change storage without changing model parameters?

Blocking conditions
- RPS or TPS is zero for an active inference workload without a valid reason.
- Training work has zero training tokens, epochs, or deadline.
- Selected option is REVIEW.
- Server or GPU quantity is fractional.
- Validation Status fails.

16.6 SHEET 4 USER GUIDE: OPTION EVALUATION
------------------------------------------

Purpose
Explain how each server/GPU candidate was evaluated for each workload.

How to use this sheet
1. Filter by Workload ID.
2. Review all candidate options.
3. Check Mode Compatible, Vendor Compatible, and Lifecycle Eligible.
4. Compare memory GPUs with throughput/training GPUs.
5. Review total required GPUs, servers, deployable GPUs, and cost.
6. Review Eligible Perf and Eligible Price.
7. Confirm the selected Performance and Price options in Sheet 3 correspond to eligible rows.

Why an option may fail
- Unsupported workload mode.
- GPU vendor preference mismatch.
- Non-GA lifecycle.
- Insufficient usable memory.
- Insufficient input or output throughput.
- Cannot meet training completion target.
- Missing price or benchmark data.

Why Performance-Optimized and Price-Optimized can be the same
The same option may be both highest-performing and lowest-cost compliant for the specific workload. This is not automatically an error. It becomes suspicious only if every workload always selects the same option despite materially different requirements.

16.7 SHEET 5 USER GUIDE: HARDWARE CATALOG
-----------------------------------------

Purpose
Maintain governed on-premises server/GPU configurations.

Who should edit
Only a controlled workbook maintainer or infrastructure architect.

Before adding or changing a record
1. Assign a unique Option ID.
2. Confirm server vendor and exact platform.
3. Confirm GPU vendor, SKU, memory, and GPUs per server.
4. Confirm supported modes.
5. Confirm lifecycle.
6. Add matched performance values and conditions.
7. Add base, GPU, and configured prices with currency/date/source.
8. Confirm fabric capability.
9. Add source URL, evidence status, and compatibility note.
10. Run option-selection regression tests.

Do not do the following
- Add a GPU without a valid server platform.
- Add a server configuration based only on physical slot count.
- Use peak theoretical FLOPS as measured application throughput.
- Enter a price without date and scope.
- Mark lifecycle GA without current evidence.

16.8 SHEET 6 USER GUIDE: CLOUD CATALOG
--------------------------------------

Purpose
Maintain provider-specific billable records for AWS, Azure, GCP, OCI, and Yotta Shakti Cloud.

Current state
The sheet provides 50 structural records but does not yet contain exact procurement-ready regional services and prices.

Required population for every record
1. Provider.
2. Service category.
3. Exact resource or SKU.
4. Accelerator type and count where applicable.
5. Memory and compute characteristics.
6. Region.
7. Billing unit.
8. Unit price.
9. Currency.
10. Price date.
11. Source URL.
12. Notes and limitations.

Cloud approval rule
A zero price means missing price, not free service. Any relevant zero or User-selected placeholder must leave the output NOT PROCUREMENT READY.

16.9 SHEET 7A USER GUIDE: CLUSTER CONSOLIDATION
-----------------------------------------------

Purpose
Show how workloads are allocated to Development or Production and grouped into compatible node pools.

How to review
1. Filter Environment to Development or Production.
2. Filter Scenario to Performance or Price.
3. Review Node Pool assignment.
4. Confirm Selected Option, GPU SKU, and Server Platform.
5. Review Workload Base GPUs.
6. Review Coincidence Factor.
7. Review Concurrent GPU Demand.
8. Review Target Utilization.
9. Review Allocated Pool GPUs and Allocation Status.
10. Review Isolation Method and limitations.

When workloads may share
- Same environment.
- Compatible mode and modality.
- Compatible selected platform and GPU architecture.
- Compatible serving/runtime stack.
- Compatible security and regulatory boundary.
- Compatible availability and DR class.
- Compatible fabric requirement.

When workloads should remain separate
- Training versus latency-sensitive inference.
- Different security zones or regulated isolation.
- Incompatible runtime or GPU partitioning requirements.
- Dedicated-node SLA.
- Different site or data-residency requirement.
- Conflicting software lifecycle.

V8.3 cautions
- Development demand uses a hardcoded 15% factor.
- Coincidence Factor is 1.0.
- Target Utilization is 75%.
- Compatibility key is incomplete.
Treat these as planning policies, not measured facts.

16.10 SHEET 7B USER GUIDE: PROCUREMENT BOM
------------------------------------------

Purpose
Provide detailed planning lines for on-premises compute, shared infrastructure, and cloud billable services.

How to review on-premises compute
1. Filter Environment and Scenario.
2. Confirm Cluster ID and Node Pool.
3. Confirm Server Vendor and Platform.
4. Confirm Server Quantity.
5. Confirm GPU Vendor, SKU, GPUs per server, and total GPUs.
6. Review CPU, RAM, boot storage, local storage, network, fabric, power, OS, platform, AI software, and support.
7. Confirm Unit Price and Extended Price.
8. Review Evidence Status and Source/Limitation.

How to review shared infrastructure
Confirm primary storage, backup/DR storage, fabric switches, optics/cables, management nodes, platform, and monitoring are counted once per environment and scenario.

How to review cloud lines
Confirm exact provider, region, SKU, quantity, hours, storage, transfer, price, price date, and source. Reject placeholder values.

Procurement readiness rule
Planning descriptions are not orderable part numbers. Procurement requires a current validated OEM configuration or cloud-provider commercial record.

16.11 HIDDEN SHEET 7 USER GUIDE: BOM FINANCIALS
-----------------------------------------------

Purpose
Retain the earlier financial calculation layer.

User guidance
Routine users should not unhide or edit this sheet. Maintainers should regression-test this sheet until duplicate logic is removed or formally retired.

Risk
Keeping multiple financial calculation layers can create inconsistent totals if one layer changes without the other.

16.12 SHEET 8 USER GUIDE: EXECUTIVE BOM FINANCIALS
--------------------------------------------------

Purpose
Provide the principal executive decision view.

How to interpret the four options
- Development Performance-Optimized: Development environment using the highest-performing eligible choices.
- Development Price-Optimized: Development environment using the lowest-cost eligible choices.
- Production Performance-Optimized: Production cluster using the highest-performing eligible choices plus Production resilience rules.
- Production Price-Optimized: Production cluster using the lowest-cost eligible choices plus Production resilience rules.

Recommended review sequence
1. Executive Decision Summary.
2. Financial Comparison.
3. Complete On-Premises Node-Pool BOM.
4. Shared Infrastructure BOM.
5. Cloud readiness.
6. Workload-to-Cluster Allocation.
7. Executive Procurement Notes.

Questions this sheet should answer
- Which environment is being sized?
- Which optimization objective is shown?
- How many active node pools, servers, and GPUs are required?
- What are compute, storage, network, and platform/software costs?
- What is the total planning CAPEX?
- Is cloud pricing complete?
- Is the result purchase ready?
- What is the major cost driver?
- What limitation still blocks procurement?

Approval guidance
Do not approve a result with REVIEW, INCOMPLETE, or NOT PROCUREMENT READY. PLANNING READY means architecture planning can continue, not that purchasing can begin.

16.13 SHEET 9 USER GUIDE: TRACEABILITY
--------------------------------------

Purpose
Audit material outputs.

How to use
1. Filter by Workload ID.
2. Select the output to investigate.
3. Review the current Value.
4. Review Input Source and Catalog Source.
5. Review Formula ID.
6. Review Evidence Status and Source URL.
7. Review Override Impact.
8. Confirm Scenario and Version.
9. Read Limitations.

Required future correction
Update older version labels to the current workbook version and add direct source/destination cell references.

16.14 SHEET 10 USER GUIDE: LOGIC TESTS
--------------------------------------

Purpose
Maintain formula definitions, policy constants, use-case catalog, model catalog, and automated tests.

How architects use the sheet
- Look up Formula IDs.
- Review symbolic formulas and limitations.
- Review policy constants.
- Verify use-case mapping.
- Verify model records.
- Review automated validation results.

How maintainers update the sheet
1. Add or modify the governed record.
2. Add owner, evidence, date, and limitation.
3. Update dependent formulas.
4. Add regression tests.
5. Run all test cycles.
6. Update Traceability and README.
7. Increment workbook version.

Do not use the sheet to
- Hide unsupported assumptions.
- Insert temporary numbers without evidence status.
- Remove failed tests to make the workbook appear valid.

16.15 USER TROUBLESHOOTING GUIDE
--------------------------------

Problem: Mapping Status is UNMAPPED.
Action: Confirm Industry and Use Case. If the combination is valid but missing, add it through controlled catalog maintenance.

Problem: Input Status is FAIL.
Action: Check mandatory fields, complexity total, demand, language, file types, environment flags, and override reason.

Problem: Model shows REVIEW.
Action: Check use-case mapping, language classification, modality, model catalog, total context, and override compatibility.

Problem: No hardware option is eligible.
Action: Filter Sheet 4 by workload and identify the failed compatibility, memory, throughput, training, lifecycle, or vendor condition.

Problem: Performance and Price select the same server.
Action: Confirm that the same option is genuinely both highest-performing and lowest-cost compliant. If all workloads behave identically, inspect option keys and eligibility formulas.

Problem: Server quantity appears too high.
Action: Check demand units, model calls, growth, HA, DR, per-workload rounding, Development factor, coincidence, utilization, and whether reserve was applied twice.

Problem: Storage appears too high.
Action: Check knowledge content, tier fallback, data growth, retention, replication, training data, vector/index factor, and duplicate protected copies.

Problem: Cloud cost is zero.
Action: Check Cloud Catalog. Zero is a missing-value placeholder and must remain NOT PROCUREMENT READY.

Problem: Executive total differs from detailed BOM.
Action: Compare environment/scenario filters, shared categories, hidden financial layer, and extended-price ranges.

Problem: Excel inserts @ into a formula.
Action: Replace unstable array formulas with standard key-based, COUNTIFS/SUMIFS, helper-column, or supported dynamic-array logic and regression-test in Microsoft Excel.

=================================================================
17. FUTURE UPDATE CHECKLIST
=================================================================

Use this checklist for every future workbook release. A release is not complete until every applicable item is checked, evidence is recorded, and regression tests pass.

17.1 RELEASE CONTROL
--------------------

[ ] Assign the new workbook version.
[ ] Record release date.
[ ] Record release owner.
[ ] Record approvers and reviewers.
[ ] Create a change log with old behavior and new behavior.
[ ] Update workbook title and all internal version labels.
[ ] Update Traceability version values.
[ ] Update README version and date.
[ ] Preserve the previous approved release as read-only.
[ ] Record formula, catalog, policy, formatting, and test changes separately.

17.2 EXECUTIVE INPUTS
---------------------

[ ] Confirm only intended cells are editable.
[ ] Confirm all dropdowns work for all 500 workload rows.
[ ] Confirm mandatory-field logic is documented.
[ ] Confirm every input includes a plain-language explanation or comment.
[ ] Confirm every material input has downstream impact.
[ ] Add explicit Annual Workload Growth with 20% default and override validation.
[ ] Add explicit Annual Data Growth with 20% default and override validation.
[ ] Add Development sizing policy inputs instead of hardcoded 15%.
[ ] Add target utilization policy input or governed workload-specific policy.
[ ] Add workload peak-overlap/schedule input.
[ ] Add RTO and RPO inputs.
[ ] Add security zone, data residency, tenancy, and regulatory isolation inputs.
[ ] Add latency targets: TTFT, ITL, P95/P99 response time.
[ ] Add cloud provider, region, pricing model, and operating schedule inputs when Cloud/Hybrid is selected.
[ ] Add group-level validation for common demand distribution.
[ ] Confirm model override requires a reason.
[ ] Confirm inactive rows contribute zero.

17.3 USE-CASE AND DEMAND MAPPING
--------------------------------

[ ] Validate every industry/use-case mapping.
[ ] Confirm workload type is derived from use case.
[ ] Confirm each use case has the correct Demand Unit.
[ ] Document the demand-to-RPS conversion for each unit.
[ ] Validate interactive and non-interactive workloads separately.
[ ] Add ingestion/OCR/video/audio-specific demand logic.
[ ] Confirm Workload Share is applied exactly once.
[ ] Add source, owner, effective date, and confidence for every mapping.
[ ] Test unmapped combinations return UNMAPPED/REVIEW.

17.4 TOKEN AND CONTEXT ENGINE
-----------------------------

[ ] Correct Language Class logic.
[ ] Add English-only, regional, and global multilingual token profiles.
[ ] Validate token tiers using representative tokenizer measurements.
[ ] Record P50 and P95 request/response token measurements.
[ ] Connect File Types to extraction and ingestion logic.
[ ] Connect Expected Answer Type to governed output-token profiles.
[ ] Connect Tool/Agent Usage to tool calls and intermediate tokens.
[ ] Add cache-hit-rate logic when prompt caching is permitted.
[ ] Confirm Model Calls per Transaction is applied once.
[ ] Add system prompt and guardrail token allowances.
[ ] Validate context calculations against model limits.
[ ] Add tests for long context and multilingual cases.

17.5 MODEL CATALOG AND SELECTION
--------------------------------

[ ] Maintain exactly the governed model scope or document approved expansion.
[ ] Validate model name, revision, license, publisher, and lifecycle.
[ ] Validate parameter count, layers, hidden size, KV heads, modality, and context.
[ ] Validate language and task eligibility.
[ ] Validate supported precision by model and runtime.
[ ] Add quality benchmark and minimum acceptance threshold.
[ ] Add evidence date and expiry.
[ ] Confirm no unsupported model becomes eligible.
[ ] Confirm no eligible-model lookup depends on unstable array behavior.
[ ] Confirm model override recalculates all downstream outputs.
[ ] Test no-eligible-model returns REVIEW.

17.6 MEMORY ENGINE
------------------

[ ] Validate bytes per parameter for every precision.
[ ] Include quantization metadata where material.
[ ] Correct KV-cache formula for GQA/MQA architecture.
[ ] Add runtime-specific cache data type.
[ ] Add continuous-batching and max-batched-token logic.
[ ] Validate runtime overhead against measured peak memory.
[ ] Validate safety margin policy.
[ ] Validate usable GPU memory by platform/runtime.
[ ] Add fragmentation and workspace allowance.
[ ] Test model fit at boundary values.

17.7 INFERENCE CAPACITY AND LATENCY
-----------------------------------

[ ] Build matched benchmark keys including model revision.
[ ] Include precision, GPU, runtime, tensor parallelism, batch, input length, and output length.
[ ] Store input TPS and output TPS separately.
[ ] Add TTFT and ITL measurements.
[ ] Add P50/P95/P99 end-to-end latency.
[ ] Add queueing and admission-control logic.
[ ] Add sustained-utilization limits by workload type.
[ ] Add burst/peak duration.
[ ] Add replicas required for SLA and draining/maintenance.
[ ] Confirm benchmark evidence is not reused across incompatible configurations.
[ ] Test sensitivity to demand, tokens, model calls, and latency targets.

17.8 TRAINING AND FINE-TUNING
-----------------------------

[ ] Separate full training, continued pretraining, full fine-tuning, LoRA, QLoRA, and embedding training.
[ ] Validate training token count and epochs.
[ ] Add sequence length and optimizer assumptions.
[ ] Add activation-checkpointing and memory requirement.
[ ] Add model-state, optimizer-state, gradient, and activation memory.
[ ] Add data-loading, checkpoint, evaluation, and restart overhead.
[ ] Add measured MFU by target stack.
[ ] Validate multi-node scaling efficiency.
[ ] Validate completion target.
[ ] Add checkpoint and training-output storage.
[ ] Test shorter deadlines increase GPU requirement.

17.9 HARDWARE CATALOG
---------------------

[ ] Cover the approved minimum server and accelerator vendors.
[ ] Maintain at least the approved GPU SKU coverage per vendor.
[ ] Validate current server platforms and lifecycle.
[ ] Add exact CPU SKU, sockets, cores, and TDP.
[ ] Add exact RAM capacity and DIMM layout.
[ ] Add boot-drive and RAID configuration.
[ ] Add local NVMe/cache configuration.
[ ] Add NIC, DPU, HBA, ports, and speeds.
[ ] Add fabric topology capability.
[ ] Add PSU and power requirements.
[ ] Add rack unit, weight, and environmental requirements.
[ ] Add exact support SKU and term.
[ ] Add OEM source and configuration-guide date.
[ ] Add dated configured quotation.
[ ] Validate no physically unsupported server/GPU combination exists.

17.10 CLOUD CATALOG
-------------------

[ ] Maintain 50 provider-specific category records or approved expanded scope.
[ ] Populate exact AWS resources.
[ ] Populate exact Azure resources.
[ ] Populate exact GCP resources.
[ ] Populate exact OCI resources.
[ ] Populate exact Yotta Shakti Cloud resources.
[ ] Add region and availability-zone availability.
[ ] Add exact GPU instance/VM shape.
[ ] Add vCPU, RAM, local storage, and accelerator count.
[ ] Add on-demand price.
[ ] Add committed/reserved price where applicable.
[ ] Add spot/preemptible option only with suitability controls.
[ ] Add exact billing unit.
[ ] Add object, block, file, vector, Kubernetes, load-balancer, monitoring, backup, and transfer pricing.
[ ] Add data-egress and inter-zone/inter-region charges.
[ ] Add support-plan cost.
[ ] Add price date, currency, source, and expiry.
[ ] Confirm zero price is treated as missing.
[ ] Confirm incomplete cloud records cannot pass procurement readiness.

17.11 CLUSTER CONSOLIDATION
---------------------------

[ ] Replace hardcoded Development factor with governed logic.
[ ] Replace fixed coincidence with evidence-backed schedule or telemetry.
[ ] Validate target utilization by workload type and SLA.
[ ] Expand compatibility key with security, residency, runtime, precision, availability, DR, and fabric.
[ ] Aggregate compatible demand before final rounding.
[ ] Add scheduler efficiency and fragmentation.
[ ] Add whole-GPU, MIG, and time-slicing policies.
[ ] Validate supported MIG profiles by GPU.
[ ] Separate training from latency-sensitive inference unless explicitly approved.
[ ] Validate dedicated-node requirements.
[ ] Validate cluster and node-pool failure domains.
[ ] Confirm workload allocation output includes every active workload.
[ ] Confirm shared components are not duplicated.
[ ] Confirm HA and DR are applied once.

17.12 STORAGE DESIGN
--------------------

[ ] Confirm direct Knowledge Content GB overrides tier fallback where provided.
[ ] Validate tier fallback values.
[ ] Add vector dimensions, data type, metadata, index type, and replicas.
[ ] Add document extraction and chunk expansion.
[ ] Add training datasets and checkpoints.
[ ] Separate logs, prompts, responses, metrics, traces, and audit retention.
[ ] Add compression and deduplication.
[ ] Add snapshots and immutable backup.
[ ] Add IOPS, throughput, and latency.
[ ] Add primary, backup, archive, and DR locations.
[ ] Add RPO/RTO requirements.
[ ] Validate storage unit rounding.
[ ] Add source and quote for every storage component.

17.13 NETWORK DESIGN
--------------------

[ ] Validate request and response payload assumptions.
[ ] Add multimodal payload logic.
[ ] Add east-west model communication.
[ ] Add storage and checkpoint traffic.
[ ] Add replication and backup traffic.
[ ] Define fabric topology.
[ ] Calculate switch radix and usable ports.
[ ] Calculate leaf/spine counts.
[ ] Calculate server, storage, management, and inter-switch ports.
[ ] Calculate optics, transceivers, and cables by link.
[ ] Add link redundancy and oversubscription.
[ ] Add management and out-of-band networks.
[ ] Validate 100/200/400/800 GbE or InfiniBand selection.
[ ] Add network equipment price and support.

17.14 HA AND DR
---------------

[ ] Replace broad factors with explicit N+1/N+2/failure-domain logic.
[ ] Define node-pool minimums.
[ ] Define control-plane quorum.
[ ] Define rack, power, switch, and site placement.
[ ] Add load-balancer redundancy.
[ ] Add storage-controller and data-path redundancy.
[ ] Add RTO and RPO.
[ ] Define Cold, Warm, and Hot implementation rules.
[ ] Add DR site/region.
[ ] Add DR storage, network, security, and licenses.
[ ] Add recovery test frequency.
[ ] Confirm DR cost is not zero for Cold DR when protected services are required.
[ ] Confirm HA and DR are not double-counted.

17.15 PROCUREMENT BOM
---------------------

[ ] Show Development and Production separately.
[ ] Show Performance-Optimized and Price-Optimized clearly.
[ ] Show workload-to-cluster allocation.
[ ] Show complete configured server lines.
[ ] Show shared infrastructure once.
[ ] Show quantities, units, unit prices, and extended prices.
[ ] Add exact part numbers.
[ ] Add source, date, validity, and evidence status.
[ ] Add tax, freight, installation, integration, and professional services.
[ ] Add rack, PDU, power, and cooling where in scope.
[ ] Add software-license metrics and support terms.
[ ] Separate CAPEX and recurring OPEX.
[ ] Add quote comparison and selected supplier.
[ ] Prevent placeholder values from appearing procurement ready.

17.16 FINANCIALS
----------------

[ ] Confirm financial scope is explicitly defined.
[ ] Confirm currency.
[ ] Add exchange-rate date if conversion is used.
[ ] Add tax and duties.
[ ] Add escalation and inflation assumptions.
[ ] Add support renewals and subscription terms.
[ ] Add energy, PUE, facilities, and operations if TCO is claimed.
[ ] Add cloud commitment and discount assumptions.
[ ] Add phased growth and purchase timing.
[ ] Add depreciation or amortization only if required and governed.
[ ] Add sensitivity ranges.
[ ] Reconcile every summary total to detailed BOM lines.
[ ] Confirm primary cost driver is based on complete scope.

17.17 EXECUTIVE OUTPUT
----------------------

[ ] Use plain-language headings.
[ ] Use Performance-Optimized and Price-Optimized consistently.
[ ] Show Development and Production separately.
[ ] Show server, GPU, storage, network, software, HA, DR, and total cost.
[ ] Show cloud monthly, annual, and planning-period cost where applicable.
[ ] Show purchase readiness.
[ ] Show evidence confidence and expiry.
[ ] Show key limitations.
[ ] Show primary cost drivers.
[ ] Show all active workload allocations dynamically.
[ ] Hide inactive rows and technical formula IDs from executive view.
[ ] Confirm no confusing zero values represent missing data.

17.18 TRACEABILITY AND GOVERNANCE
---------------------------------

[ ] Update all Formula IDs.
[ ] Add direct source and destination cell references.
[ ] Add catalog record IDs.
[ ] Add evidence snapshot IDs.
[ ] Add formula owner and policy owner.
[ ] Add effective and review dates.
[ ] Add confidence and expiry status.
[ ] Add override impact.
[ ] Add workbook version.
[ ] Add release signature or formula hash where possible.
[ ] Confirm every material output is traceable.

17.19 FORMULA INTEGRITY TESTS
-----------------------------

[ ] No circular references.
[ ] No #VALUE! errors.
[ ] No #REF! errors.
[ ] No #DIV/0! errors.
[ ] No #N/A errors in expected paths.
[ ] No #NAME? errors.
[ ] No #NUM! errors.
[ ] No unintended @ implicit-intersection operators.
[ ] No unstable array formulas where standard formulas are required.
[ ] No formulas referencing overwritten header cells.
[ ] No inactive-row contribution.
[ ] No duplicated model-call multiplier.
[ ] No duplicate HA or DR reserve.
[ ] No duplicated shared infrastructure.
[ ] All physical quantities are integers.

17.20 FUNCTIONAL AND SENSITIVITY TESTS
--------------------------------------

[ ] Validate at least 10 active workloads.
[ ] Validate simple, medium, and complex mix changes.
[ ] Validate each Demand Unit.
[ ] Validate English-only, regional, and multilingual paths.
[ ] Validate text, RAG, multimodal, video, audio, fine-tuning, and training.
[ ] Validate model override.
[ ] Validate vendor preference.
[ ] Validate Standard, High Availability, and Fault Tolerant.
[ ] Validate None, Cold, Warm, and Hot DR.
[ ] Validate Development-only, Production-only, and both.
[ ] Validate 1-year, 3-year, and 5-year planning periods.
[ ] Validate On-Premises, Cloud, and Hybrid.
[ ] Validate Performance-Optimized and Price-Optimized divergence.
[ ] Validate same option is allowed when genuinely optimal for both.
[ ] Validate workload consolidation.
[ ] Validate incompatible workload isolation.
[ ] Validate knowledge content changes storage only where intended.
[ ] Validate training deadline changes training GPU quantity.
[ ] Validate every material input changes the correct downstream result.

17.21 PROCUREMENT-READINESS TESTS
---------------------------------

[ ] Every on-premises server has a validated complete configuration.
[ ] Every on-premises price has a dated quote.
[ ] Every cloud resource has provider, region, exact SKU, quantity, unit, price, and date.
[ ] Every support and software line has a licensing basis.
[ ] Every storage line has capacity and performance basis.
[ ] Every network line has topology and quantity basis.
[ ] Every shared component is counted once.
[ ] All incomplete records are clearly blocked.
[ ] Executive totals reconcile to detailed BOM.
[ ] Procurement status cannot pass while material evidence is missing.

17.22 DOCUMENTATION AND RELEASE COMPLETION
------------------------------------------

[ ] Update the complete README.
[ ] Update Formula Glossary.
[ ] Update Assumptions Glossary.
[ ] Update Sheet-by-Sheet User Guide.
[ ] Update Future Update Checklist.
[ ] Update known-defects list.
[ ] Update release roadmap.
[ ] Update operating instructions.
[ ] Update change-management rules.
[ ] Update supported Excel version.
[ ] Archive test evidence.
[ ] Obtain architecture review.
[ ] Obtain commercial/procurement review where required.
[ ] Obtain final release approval.

=================================================================
18. QUICK USER CHECKLIST
=================================================================

Before using results
[ ] Global inputs are complete.
[ ] Every active workload is MAPPED and PASS.
[ ] Complexity totals equal 100%.
[ ] Demand units are appropriate.
[ ] Development and Production flags are correct.
[ ] No material output shows REVIEW or FAIL.
[ ] Selected models are eligible.
[ ] GPU/server quantities are plausible and whole.
[ ] Cluster allocations are compatible.
[ ] Shared components are not duplicated.
[ ] Performance-Optimized and Price-Optimized are clearly understood.
[ ] Cloud output is ignored unless exact cloud data is populated.
[ ] Prices are current or clearly labelled planning estimates.
[ ] Executive totals reconcile to detailed BOM.
[ ] Procurement is blocked if evidence or quotation is incomplete.

=================================================================
19. FINAL DOCUMENT CONTROL NOTE
=================================================================

This README documents <File>AI_Infrastructure_Sizing_v8.3_Clear_Executive_BOM.xlsx</File> as of 18 September 2026. Any change to formulas, assumptions, policies, catalogs, selection logic, sheet structure, or readiness rules requires a matching README update, a version increment, and full regression testing.

End of README.
