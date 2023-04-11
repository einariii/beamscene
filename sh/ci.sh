#!/bin/bash

MIX_ENV=test

mix test
mix hex.audit
mix deps.audit
mix sobelow
mix format
mix credo --strict
mix dialyzer
