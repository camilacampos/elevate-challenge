# Elevate Labs Challenge

Refer to [challenge_description.md](challenge_description.md) to check the description of the challenge.

## Setup
| Dependency     | Version     |
| -------------- | ----------- |
| Ruby           | **3.4.4**   |
| Sqlite3        | **3.43.2**  |

## Running

Install dependencies:
```
bundle install
```
Run migrations:
```
rails db:migrate
```
Start the application:
```
rails server
```
Run tests:
```
rspec
```
Run linter:
```
standardrb

standardrb --fix
```

## Example Requests

**Create user**
```bash
curl -i -X POST localhost:3000/api/user \
  --json '{"email": "camila@example.com", "password": "pass1234"}'
```

**Create session**
```bash
curl -i -X POST localhost:3000/api/sessions \
  --json '{"email": "camila@example.com", "password": "pass1234"}'
```

**Show logged user info**
```bash
curl -i \
  --header "Authorization: Bearer {token}" \
  localhost:3000/api/user
```
> substitute {token} with token gotten from `create session` request

**Game Completion Ingestion**
```bash
curl -i \
  --header "Authorization: Bearer {token}" \
  -X POST localhost:3000/api/user/game_events \
  --json '{
        "game_event": {
          "game_name": "Brevity",
          "type": "COMPLETED",
          "occurred_at": "2025-01-01T00:00:00.000Z"
        }
      }'
```
> substitute {token} with token gotten from `create session` request

## Decision making and thought process

> TODO
