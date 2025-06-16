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

Please take a look on [PR descriptions](https://github.com/camilacampos/elevate-challenge/pulls?q=is%3Apr+is%3Aclosed) for a more detailed explation into the decision process.

### Architecture

**Use cases** are being used to process business logic, avoiding fat controllers or fat models. This also enables different entrypoints for the same use cases, or reusing logic for different process. [Dry-validations gem](https://dry-rb.org/gems/dry-validation/1.10/) were chosen to validate inputs for use cases, since it supports both simple and complex validations, as well as data coercion and normalization.

**Infra services** are being used to connect to external sources, such as other HTTP APIs.

**Authentication** is made using [JWT gem](https://github.com/jwt/ruby-jwt), instead of relying in a more robust authentication tool like Devise, since requirements for it are quite basic. A future (and simple) evolution would be persisting session info, be helpful for tracking sessions, managing login history, or invalidating specific tokens.

### Business decisions
**Total games played:** challenge description did not specify what we should consider as `total_games_played`. Possible implementations are:
1. total of distinct games **played** by the user, regardless of status -> _`CURRENT IMPLEMENTATION`_
1. total of distinct games **completed** by the user (although completed is the only possible game event currently, we could start to track different statuses as well)
1. total of times any game was **completed** by the user (basically count COMPLETED game events instead of distinc games)
1. total of times any game was **played** by the user, regardless of status (basically count game events instead of distinc games)

For the sake of simplicity, I went with (1).

**Billing service errors:** challenge description did not specify what should happen when requests to the Billing Service fail. Currently, any error on the external service implies in an error being returned to the client, also for simplicity. Other possible approaches are:
1. Return other user info for the client, with `subscription_status: nil`, logging the errors instead of returning them. This would be a more user-friendlier and error resilient approach, because an error on a service wouldn't have an major impact in any other.
    - instead of `nil`, it would be possible to return another "placeholder" value, such as "unknown" or "unavailable"
1. Same as before, but only for general errors. If users are not found by the Billing Service, the service also returns an error to the client.
    - this approach means that it could have inconsistencies between users in different services.
