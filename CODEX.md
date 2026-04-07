# 🧠 Project Context: UristUslugi

## 📌 Overview
UristUslugi is an online legal services platform.

Stack:
- Ruby on Rails 8.1.3
- PostgreSQL
- Hotwire (Turbo + Stimulus)
- Tailwind CSS

Users:
- Admin (full access)
- Client (creates service requests)
- Lawyer (processes requests)

---

## 🧩 Domain Models

### User
Roles:
- admin
- client
- lawyer

### ServiceRequest
Statuses:
- pending
- in_progress
- completed
- rejected

### Other Models
- Category
- Service
- Notification

---

## 🏗 Architecture Rules

- Keep controllers thin
- Move business logic to service objects (app/services)
- Use concerns for shared logic
- Prefer PORO services over fat models
- Do not put complex logic in callbacks
- Use scopes and enums consistently
- Follow RESTful conventions

---

## ⚠️ Critical Constraints

- ❌ Do NOT break existing routes
- ❌ Do NOT change DB schema unless explicitly requested
- ❌ Do NOT introduce breaking API changes
- ❌ Do NOT duplicate logic

- ✅ Always follow existing roles and permissions
- ✅ Preserve ServiceRequest lifecycle logic
- ✅ Keep backward compatibility

---

## 📂 Code Guidelines

- Prefer small, focused changes (1 task = 1 change)
- Avoid large refactors unless explicitly requested
- Use meaningful method names (English only)
- Keep code DRY and readable
- Remove dead/commented code

---

## 🚀 Development Rules

When implementing features:

1. First explain the plan
2. Then implement step-by-step
3. Prefer minimal diff
4. Show only changed code when possible

---

## 🧪 Testing Rules

- Ensure critical flows work:
    - creating ServiceRequest
    - updating status
    - role-based access

- Prefer RSpec (if both frameworks exist)

---

## ⚡ Performance Rules

- Avoid N+1 queries
- Use includes / preload when needed
- Optimize DB queries before adding complexity

---

## 🔐 Security Rules

- Do NOT disable CSRF unless explicitly required
- Validate all user inputs
- Respect role-based authorization
- Keep Devise auth forms on `form_with`/`form_for` paths that include CSRF tokens.
- Do not add `skip_before_action :verify_authenticity_token` to web login or registration actions.
- Keep JWT request injection scoped to API controllers and the Devise session destroy flow only; do not inject JWT into all HTML requests.
- For Devise sign-in redirects, preserve `stored_location_for(resource)` before falling back to role-based paths.
- Never send non-admin users to `/admin` from `stored_location_for`; fall back to `root_path` instead.
- Registration forms must include `first_name` and `last_name`, because `User` validates them.
- Permit sign-up and account update params for `first_name` and `last_name` in `ApplicationController`.

---

## 🤖 Codex Behavior Rules

- Work ONLY on requested files unless necessary
- Do NOT analyze entire project unless asked
- Keep responses concise
- Prefer code over explanations when implementing

---

## 📎 Useful Commands

- Start server: `bin/rails server`
- Migrate DB: `bin/rails db:migrate`
- Seed DB: `bin/rails db:seed`

---

## 🧠 Important Notes

- This is a production-oriented project
- Stability > clever solutions
- Simplicity > abstraction

---

## ✅ Definition of Done

A task is complete when:
- Code works
- No existing functionality is broken
- Code follows project rules
- Minimal and clean implementation
