# Wercker Bugsnag Deploy Tracking After Step

A Wercker deploy after step that notifies Bugsnag about any new deploys or releases of your application.

Using Bugsnag's deploy tracking API: https://docs.bugsnag.com/api/deploy-tracking/

## Options

* `api_key` The Bugsnag API key
* `stages` Comma separated list of stages applicable for deployment tracking

The step requires a `STAGE` environment variable to be present during the execution of the deploy pipeline,
in order to pass this on to the Bugsnag api as the current release stage. This variable should resemble
the release stages that may also be in use for error tracking.

## Example

```
deploy:
    after-steps:
        - bugsnag-deploy-tracking-notify:
            api_key: $BUGSNAG_API_KEY
            stages: "production"
```
