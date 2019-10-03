# Merge Control Github Action

A Github action to check whether a merge/PR is permitted to happen between branches based on user-supplied rules.

## How to Use
1. Create a new action to trigger on (typically) a pull request,
2. Within `jobs.<job_id>.steps` of the action workflow, add a `uses` statement similar to the following (see below for use of the `with` statement).
   ```yml
   - uses: konsentus/action.control-merge@master
     with:
       all: "hotfix/*"
       prod: "sandbox alpha"
       sandbox: "alpha"
       alpha: "sit"
       sit: "feature/*"
   ```

## Using the `with` statement

The with statement is used for this action to provide a list of keys for destination branches along with a string value containing a space separate list of branches allowed to merge into it.

The `all` key is a special case, where the list of branches listed here are permitted to merge in all branches in the repository.

Wildcards as allowed by `grep` are permitted in the source branch values, such as `hotfix/*`.
