if [ -z "${NGROK_TOKEN}" ]; then
    echo "Error: NGROK_TOKEN is not set. Please set it in your .env file." >&2
    exit 1
fi

if [ -z "${REGION}" ]; then
    echo "Warning: REGION is not set. Defaulting to 'us' region."
    REGION="us"
fi

pgrep rclone
if [ $? -eq 0 ]; then
    echo "Already mounted, skipping."
else
    echo $BASE_CONF | base64 -d > .rclone.conf
    rclone serve sftp "$CLOUD_NAME":$SUB_DIR --no-auth --vfs-cache-mode full &
fi

