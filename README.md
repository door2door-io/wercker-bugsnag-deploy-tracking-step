# Wercker Bugsnag Deploy Tracking After Step

A Wercker deploy after step that notifies Bugsnag about any new deploys or releases of your application.

Using Bugsnag's deploy tracking API: https://docs.bugsnag.com/api/deploy-tracking/

## Options

* `api_key` The Bugsnag API key
* `release_stage` The stage to track deployment for

The value for the release stage should resemble one of the release stages
that are also in use for error tracking w/ Bugsnag. When using the step in
more than just one pipeline in an application you can use an environment
variable in order to define the release stage per pipeline, e.g.
`release_stage: $RELEASE_STAGE`.

## Example

```
deploy:
    after-steps:
        - bugsnag-deploy-tracking-notify:
            api_key: $BUGSNAG_API_KEY
            release_stage: "production"
```
