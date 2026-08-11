# The Long Road Club

A Rails 8 community for Indian motoring enthusiasts. It combines an editorial, retro-automotive interface with a database-backed forum, member accounts, events, garages, guides, and newsletter membership.

## Setup

```bash
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails tailwindcss:build
bin/rails server
```

Open `http://localhost:3000`.

## Demo member

- Email: `aarav@example.com`
- Password: `longroad2026`

The seed task is idempotent and creates five members, six categories, four discussions with replies, two upcoming events, a featured garage, and three guides.

## Backend

- Cookie-based member sessions using `has_secure_password`
- Discussions with categories, friendly slugs, status, view counts, replies, and owner/moderator authorization
- Persistent member bookmarks with JSON endpoints for the Stimulus interface
- Events with capacity-aware RSVPs
- Published garage features and workshop guides
- Idempotent newsletter subscriptions
- HTML views plus JSON responses for discussion lists and detail pages

Useful JSON endpoints:

```text
GET  /discussions.json
GET  /discussions/:slug.json
POST /discussions/:slug/bookmark.json
DELETE /discussions/:slug/bookmark.json
```

## Verification

```bash
bin/rails test
bin/rails zeitwerk:check
RUBOCOP_CACHE_ROOT=/private/tmp/long-road-rubocop-cache bin/rubocop app config/routes.rb db/seeds.rb test
```
