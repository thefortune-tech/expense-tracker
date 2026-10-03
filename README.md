# Expense Tracker 

A local-first, multi-currency expense tracker built with Flutter, using strict Clean Architecture, BLoC/Riverpod hybrid state management, and hand-written Hive persistence — no backend, no cloud dependency, fully offline by design.

![Flutter](https://img.shields.io/badge/Flutter-3.41.5-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.11.3-0175C2?logo=dart&logoColor=white)
![CI](https://github.com/thefortune-tech/expense-tracker/actions/workflows/ci.yml/badge.svg)
![License](https://img.shields.io/badge/license-MIT-green)

---

## Overview

Expense Tracker is the third project in a Flutter portfolio series (after Job Tracker and AI Crypto Chat), built specifically to demonstrate a different architectural skill set: local-only data persistence, offline-first design, and multi-currency handling — as opposed to AI Crypto Chat's cloud-backed, Firebase-driven approach.

Core flows:
- Local profile setup with optional PIN lock (no cloud auth)
- Add/edit/delete transactions with multi-currency support
- Transaction history, grouped by day, filterable by type
- Dashboard with monthly income/expense summary and category breakdown (fl_chart)
- Per-category monthly budgets with usage tracking

---

## Architecture

This app follows strict Clean Architecture with a feature-first folder structure — each feature (auth_profile, transactions, dashboard, budget) contains its own domain/, data/, and presentation/ layers.

lib/
- core/ — Shared: error handling, DI, theme, currency, use case base
- features/
  - auth_profile/ — Local login, PIN, profile management (domain, data, presentation with Riverpod)
  - transactions/ — Add/edit/delete/list transactions (domain, data, presentation with BLoC)
  - budget/ — Category budgets and usage tracking (domain, data, presentation with BLoC)
  - dashboard/ — Aggregated summary and charts (domain only — no data layer, reads from transactions & budget repos; presentation with Riverpod + fl_chart)

Why feature-first over layer-first: with four largely independent features, grouping by feature keeps everything related to one concern in one place, rather than scattering entities/use cases/pages across separate top-level domain/, data/, presentation/ folders. This mirrors how most production Flutter teams structure larger apps — it scales better as features are added, without needing a restructure.

### Layers

- Domain — pure Dart, zero Flutter/Hive dependencies. Entities, abstract repository contracts, use cases, validators.
- Data — Hive models (hand-written TypeAdapters, no code generation), local data sources, repository implementations that translate exceptions into typed Failures.
- Presentation — BLoC for transactions and budget (event-driven, multi-state flows); Riverpod for auth_profile and dashboard (simpler, more linear state).

### Error handling

Every operation that can fail returns Either<Failure, T> via fpdart — no exceptions cross layer boundaries. Failure subtypes (CacheFailure, ValidationFailure, NotFoundFailure, UnexpectedFailure) let the presentation layer react meaningfully to what went wrong, not just that something did.

### Dependency injection

get_it wires the entire object graph — Hive boxes → data sources → repositories → use cases — at app startup, once. Repositories and use cases are registered as lazy singletons; BLoCs are registered as factories, since each screen needs its own fresh instance.

### Why BLoC and Riverpod

- BLoC (transactions, budget) — features with multiple discrete user-triggered events (add/edit/delete/filter) and clear loading/loaded/error state machines.
- Riverpod (auth_profile, dashboard) — simpler, more linear state (a launch-time status check, a month-scoped summary fetch) where a direct Notifier with method calls is a more natural fit than an event stream.

---

## Tech stack

State management: flutter_bloc, flutter_riverpod
Local storage: hive, hive_flutter (hand-written TypeAdapters, no build_runner)
Functional error handling: fpdart
Dependency injection: get_it
Charts: fl_chart
Testing: flutter_test, bloc_test, mocktail

Note on Hive code generation: hive_generator currently has an unresolved analyzer version conflict with bloc_test's dependency chain, so this project hand-writes all TypeAdapters instead of relying on build_runner. This is a deliberate, documented trade-off — see Known Trade-offs below.

---

## Getting started

git clone https://github.com/thefortune-tech/expense-tracker.git
cd expense-tracker
flutter pub get
flutter run

Requires Flutter 3.41.5+ / Dart 3.11.3+.

---

## Testing

flutter test

The suite covers:
- 6 use case unit tests — validation logic, failure propagation, and correct delegation (AddTransaction, UpdateTransaction, DeleteTransaction, CreateProfile, SetBudget, GetDashboardSummary)
- 1 BLoC test — full event-to-state transitions for TransactionBloc, including the mutate-then-reload pattern and short-circuit-on-failure behavior
- 1 widget test — TransactionListTile rendering, formatting, and gesture interaction (tap, swipe-to-delete)

This is a deliberately focused, not exhaustive suite — see Known Trade-offs for what's intentionally not covered and why.

---

## CI/CD

GitHub Actions runs on every push/PR to main:
1. Format check (dart format --set-exit-if-changed)
2. Static analysis (flutter analyze --fatal-infos)
3. Full test suite with coverage
4. Release APK build (on main only, after the above pass) — uploaded as a downloadable workflow artifact

See .github/workflows/ci.yml.

---

## Known trade-offs

Being upfront about deliberate scope decisions, rather than presenting this as more complete than it is:

- No cross-currency conversion. Transactions support multiple currencies, but budget usage tracking and dashboard totals assume transactions are logged in the same currency as the relevant budget/summary — there's no live exchange-rate fetching. Multi-currency is demonstrated at the transaction level, not reconciled across currencies.
- PIN is a local convenience gate, not security. The optional 4-digit PIN is stored and compared in plain text — it's meant to deter casual access (e.g. a family member picking up the phone), not to be cryptographically secure. Real authentication would require actual cloud auth, out of scope for a local-only app.
- Mutations trigger a full re-fetch, not optimistic updates. After adding/editing/deleting a transaction or budget, the BLoC re-fetches the full list from Hive rather than surgically updating in-memory state. Simpler and always-correct by construction; the cost is negligible for local Hive reads.
- Some category-spend aggregation logic is duplicated between dashboard and budget (both independently compute "spend per category for a month" from the same transaction list). A shared use case both could call is a reasonable future refactor.
- Categories are plain strings, not a modeled entity. No icons, colors, or subcategories — kept simple for v1.
- Dashboard currency display is currently hardcoded to NGN rather than pulled from the user's defaultCurrencyCode — a known gap, not a deliberate design choice.
- Test suite is focused, not exhaustive. Pass-through use cases with no branching logic (GetAllTransactions, GetTransactionById, UpdateProfile, VerifyPin, GetBudgetsForMonth, GetBudgetForCategory, DeleteBudget) are not independently unit-tested, since they contain no logic beyond delegation.
- No sealed-class state modeling. ProfileState, TransactionState, etc. use a single class with nullable fields and a status enum, rather than a sealed hierarchy with one subclass per state. Simpler for this app's state-machine size.

---

## Roadmap (not implemented)

- Currency conversion via a live exchange-rate API
- Optional cloud backup/sync (the local-first design leaves room for this without a rewrite)
- Recurring transactions
- CSV export
- Light theme toggle

---

## License

MIT
