(Robot Framework)

This repository is a demo QA automation project for **API + UI testing** using **Robot Framework** (Portfolio purpose).

## Robot Framework
Install Robot Framework

Install libraries via command:

```bash
py -m pip install robotframework
py -m pip install robotframework-requests
py -m pip install robotframework-jsonlibrary
py -m pip install robotframework-seleniumlibrary

```
## Python
Install Python 3.12.10
Add Python to PATH

## Command to run test case
Run API Tests
```bash
py -m robot tests/test_get_api.robot
py -m robot tests/test_post_api.robot
py -m robot tests/test_put_api.robot
py -m robot tests/test_delete_api.robot

```

Run UI Test
```bash
py -m robot tests/test_ui.robot

```

## Project Structure
SAUCEDEMO_TEST1/
├── data/
│   ├── login_data.json
│   └── post_user_data.json
├── resources/
│   ├── keywords_api.robot
│   └── keywords_ui.robot
├── tests/
│   ├── test_get_api.robot
│   ├── test_post_api.robot
│   ├── test_put_api.robot
│   ├── test_delete_api.robot
│   └── test_ui.robot
├── results/
│   ├── output.xml
│   ├── report.html
│   └── log.html
├── videos/
│   └── recording_1.webm
├── interactive_console_output.xml
└── requirements.txt

## API Endpoints (ReqRes – Public API)
## 1) GET Single User
Endpoint
GET https://reqres.in/api/users/2
Expected Response Status: 200
Example Response
```text
{
  "data": {
    "id": 2,
    "email": "janet.weaver@reqres.in",
    "first_name": "Janet",
    "last_name": "Weaver",
    "avatar": "https://reqres.in/img/faces/2-image.jpg"
  },
  "support": {
    "url": "https://contentcaddy.io?utm_source=reqres&utm_medium=json&utm_campaign=referral",
    "text": "Tired of writing endless social media content? Let Content Caddy generate it for you."
  }
}

```

## 2) POST Create User
Endpoint
POST https://reqres.in/api/users
Example Request
```text
{
  "name": "morpheus",
  "job": "leader"
}
```

Expected Response Status: 201
Example Response
```text
{
  "name": "morpheus",
  "job": "leader",
  "id": "643",
  "createdAt": "2025-08-17T08:46:20.076Z"
}
```

## 3 PUT Update User (Full Update)
Endpoint
PUT https://reqres.in/api/users/2
Example Request
```text
{
  "name": "morpheus",
  "job": "zion resident"
}
```

Expected Status: 200
Example Response
```text
{
  "name": "morpheus",
  "job": "zion resident",
  "updatedAt": "2025-08-17T09:10:20.076Z"
}
```

## 7) DELETE User
Endpoint
DELETE https://reqres.in/api/users/2
Expected Status: 204
Response Body: (empty)



## Auth Type
ReqRes public API typically works without auth for demo endpoints.
```text
Auth Type: API Key
protocol: https://
host: reqres.in/
uri: api
api_key_name: x-api-key
api_key: reqres-free-v1
Example URL: {{protocol}}{{host}}{{uri}}/users
```