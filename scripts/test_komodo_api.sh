#!/usr/bin/env bash

komodo_api_key=""
komodo_api_secret=""
url=""

curl -s -X POST \
      -H "Content-Type: application/json" \
      -H "X-Api-Key: $komodo_api_key" \
      -H "X-Api-Secret: $komodo_api_secret" \
      -d '{ "type": "ListStacks", "params": {} }' \
      "${url}/read/ListOnboardingKeys"

