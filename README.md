# Terraform training

## Import existing resources
```
PROJECT_ID="big-pact-347415"
tf import google_storage_bucket.bucket $PROJECT_ID-static-content
tf import google_app_engine_application $PROJECT_ID
```
