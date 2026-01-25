mkdir -p logs sessions
chmod -R 777 logs sessions
APP_KEY=$(echo "base64:$(head -c 32 /dev/urandom | base64)")
if grep -q "APP_KEY=" .env; then
    if [[ "$(uname)" == "Darwin" ]]; then
        sed -i '' "s/APP_KEY=.*/APP_KEY=$APP_KEY/" .env
    else
        sed -i "s/APP_KEY=.*/APP_KEY=$APP_KEY/" .env
    fi
else
    echo "APP_KEY=$APP_KEY" >> .env
fi