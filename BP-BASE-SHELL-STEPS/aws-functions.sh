function bucketExist() {
    BUCKET=$1

    BUCKET_EXISTS=$(aws s3api head-bucket --bucket $BUCKET 2>&1 || true)
    if [ -z "$BUCKET_EXISTS" ]; then
        echo 0
    else
        echo 1
    fi
}

function copyFileToS3() {
    SOURCE_FILE=$1
    S3_BUCKET=$2
    KEY_NAME=$3

    aws s3 cp ${SOURCE_FILE} s3://${S3_BUCKET}/${KEY_NAME}
}

function copyFileFromS3() {
    S3_BUCKET=$1
    FILE_KEY=$2
    FILE_PATH=$3
    aws s3 cp s3://${S3_BUCKET}/${FILE_KEY} ${FILE_PATH} 
}