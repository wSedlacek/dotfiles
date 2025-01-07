function destroyEnvironment -a pullRequestId
  NX_BATCH_MODE=true PULL_REQUEST_ID=$pullRequestId nx run-many --all --configuration review --target tfinit --output-style stream
  NX_BATCH_MODE=true PULL_REQUEST_ID=$pullRequestId nx run-many --all --configuration review --target destroy --output-style stream
end