# Repository Structure

The repository uses a modular monolith. UI features are organized by business capability. The FastAPI backend uses versioned routers and will later separate domain, application and infrastructure layers. This supports growth without premature microservices.

Dependency direction:
`pages -> features -> shared components`

Backend target direction:
`api -> application -> domain`, with infrastructure adapters at the outside.
