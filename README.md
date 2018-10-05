# Zuora input plugin for Embulk

TODO: Write short description here and embulk-input-zuora.gemspec file.

## Overview

* **Plugin type**: input
* **Resume supported**: yes
* **Cleanup supported**: no
* **Guess supported**: no

## Configuration


- **base_url**: Base URL for REST API endpoint (string, required)
- **auth_method**: `basic` or `oauth` (string, default: `null`, required) # oauth is to be added
- **username**: Username(email address). Required if `auth_method` is `basic` (string, default: `null`)
- **password**: Password for the username above. Also Required if `auth_method` is `basic` (string, default: `null`)
- **query**: ZOQL (Zuora Obeject Query Language) query. Required if call with query (string, default: `null`) # note: please refer to ZOQL documentation
- **object**: Target Zuora object name. Required if `query` is not set (string, default: `null`)
- **where**: Filter condition for query. Required if `query` is not set (string, default: `null`)
- **retry_limit**: Maximum counts to retry (integer, default: 5)
- **retry_wait_sec**: Seconds to wait before retrying (integer, default: 5)

## Example

```yaml
in:
  type: zuora
  base_url: https://rest.zuora.com
  auth_method: basic
  username: zuora@example.com
  password: example_password
  query: "Select * From Account"
```

```yaml
in:
  type: zuora
  base_url: https://rest.zuora.com
  auth_method: basic
  username: zuora@example.com
  password: example_password
  object: Account
  where: "CreatedDate > '2018-09-08 00:00:00'"
  columns:
    - { name: Id, type: string }
    - { name: AccountNumber, type: long }
  retry_limit: 10
  retry_wait_sec: 10
```


## Build

```
$ rake
```
