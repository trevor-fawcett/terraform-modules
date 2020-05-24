# CodePipeline Module

Provides a CodePipeline with source, test and package stages, plus associated roles/policies.

## Problem!

Unfortunately, this module has to assume the user wants a test and package stage.
There's no way to add stages to an empty pipeline, which might have made this more flexible.

Since pipelines will likely have a number of stages associated with the type of solution being deployed, it makes sense to build a set of "complete" pipeline modules that satisfy the use-cases of my software.

## Use-cases for Pipelines

These are the first 2 to tackle, each with three stages, but the deploy stage is unique to the type of solution.

- Test, package and deploy a Lambda
- Test, package and deploy a Web Application to an S3 Bucket