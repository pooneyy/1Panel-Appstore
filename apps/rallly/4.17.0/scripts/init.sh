NEW_SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 32)
if grep -q "SECRET_PASSWORD=" .env; then
    if [[ "$(uname)" == "Darwin" ]]; then
        sed -i '' "s/SECRET_PASSWORD=.*/SECRET_PASSWORD=$NEW_SECRET/" .env
    else
        sed -i "s/SECRET_PASSWORD=.*/SECRET_PASSWORD=$NEW_SECRET/" .env
    fi
else
    echo "SECRET_PASSWORD=$NEW_SECRET" >> .env
fi