# Elevate Labs Challenge - Description

Copied from: https://you.ashbyhq.com/elevate-labs/assignment/28cfa361-001f-4209-b2fa-9e845362cb54

## Practical Coding Assessment - Backend

You’re going to build a RESTful backend for an existing mobile app. The app allows users to log in, submit game completion information, and view some basic summary statistics. Assume that the mobile app is already built and the backend needs to match its API expectations.

This project is expected to take no more than an evening of your time to complete. Completion of these initial phases is required, as there will be a follow-up session to expand its functionality and discuss your code and thought process.

Given that this is a take-home project, we don’t restrict the use of AI tools. However, you should be able to explain and stand behind every decision. It’ll be tough to succeed in the follow-up session without a strong understanding of what you submit.

Please ask questions if you have any while working on this project.

## Requirements

1. Use Ruby on Rails to build this project. During the practical coding session, we’ll add more features on top of what you built. ruby "3.3.5" is preferred.

1. Please commit any credentials (config/master.key or .env) required to run your project. Alternatively, you can upload them separately with your Ashby submission.

1. The API should use JSON as the preferred content type.

1. The app should be runnable and incorporate automated tests.

1. Include a README with:
    1. Clear instructions on how to run the project and tests.

    1. Any other relevant notes you think might be helpful.

    1. Assume the reader is a software developer but not an expert in this platform.

1. Add brief explanations (in your own words) for key design decisions - either in the README or as comments in your code. This helps show that you understand the choices you made, even if you used AI to help.


## Phase 1 - Sign-up and Authentication

The client should be able to sign up a new user and, once signed-up, provide a user’s credentials to the backend and have that user become “logged-in”. We would like this to follow best practices for security.

The signup endpoint will be hosted at /api/user using a POST verb. A user should have an email and password. The API will receive the new user’s information in JSON format and reply with a “201 Created” on success.
```
{
    "email": "example@example.com",
    "password": "strong_password"
}
```

_**Request** Payload to POST http://localhost:3000/api/user_

For login the path should be /api/sessions and the request will arrive as a POST with the credentials in JSON format similar to the create endpoint. Return a token for the user.
```
{
  "token": ...
}
```
_**Response** to POST http://localhost:3000/api/sessions

Subsequent API requests should be restricted to logged-in users.


## Phase 2 - Game Completion Ingestion

The client will post a completion event every time a game is completed. (A game can be completed multiple times.) This will be a POST to the endpoint /api/user/game_events. The only accepted type field is "COMPLETED"
```
{
  "game_event": {
    "game_name":"Brevity",
    "type":"COMPLETED",
    "occurred_at":"2025-01-01T00:00:00.000Z"
  }
}
```
_**Request** payload POST http://localhost:3000/api/user/game_events_



## Phase 3 - User Details and Stats

The client will request the user details after login and each time the application opens to get the latest stats and any changes to the user details. This will be a GET request to http://localhost:3000/api/user/ .
```
{
  "user": {
    "id": 54321,
    "email": "test@example.com"
    "stats": {
      "total_games_played": 5,
    }
  }
}
```
_**Response** to GET http://localhost:3000/api/user/_

## Phase 4 - User Subscription status

The last step of this take home is to show the user’s subscription status on the /api/user GET request.
```
{
  "user": {
    "id": 54321,
    "email": "test@example.com"
    "stats": {
      "total_games_played": 5,
    },
    "subscription_status": "active"
  }
}
```
_**Response** to GET http://localhost:3000/api/user/_



In order to do so, you will have to integrate with the billing service that will return static values for the sake of this exercise. The service has been built as a testing ground. Thus, you can test for intermittent failures with the user_id=5 and every user_id > 100 will return a not_found error.

You can get the user’s subscription status with a request to
```
GET https://interviews-accounts.elevateapp.com/api/v1/users/:user_id/billing
```
To authenticate with the service, you can use the JWT token:

`eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiaWxsaW5nIiwiaWF0IjoxNzQzMDg1NDk5LCJleHAiOm51bGwsImF1ZCI6Ind3dy5leGFtcGxlLmNvbSIsInN1YiI6ImJpbGxpbmdfY2xpZW50In0.aRwnR_QP6AlOv_JanMkbhwe9ACDcJc5184pXdR0ksXg`

```
{
	"subscription_status": "active" | "expired"
}
```

_**Response** to GET https://interviews-accounts.elevateapp.com/api/v1/users/:user_id/billing_



Note: the service recalculates the subscription status of users every 24h.
