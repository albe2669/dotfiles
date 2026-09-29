#!/usr/bin/env bash

nix-collect-garbage -d
nix-store --gc
go clean -cache
go clean -modcache
