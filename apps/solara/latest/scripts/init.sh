#!/bin/bash
if [[ ! -f ".env" ]]; then
    exit 1
fi
NEW_SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 32)
if grep -q "SESSION_SECRET=" .env; then
    if [[ "$(uname)" == "Darwin" ]]; then
        sed -i '' "s/SESSION_SECRET=.*/SESSION_SECRET=$NEW_SECRET/" .env
    else
        sed -i "s/SESSION_SECRET=.*/SESSION_SECRET=$NEW_SECRET/" .env
    fi
else
    echo "SESSION_SECRET=$NEW_SECRET" >> .env
fi
