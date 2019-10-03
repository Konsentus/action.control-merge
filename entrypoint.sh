#!/bin/bash -l

if [ -z "$GITHUB_HEAD_REF" ] || [ -z "$GITHUB_BASE_REF" ]; then
    # expected env vars dont exist, cannot continue
    echo "Either GITHUB_HEAD_REF or GITHUB_BASE_REF are not defined. Cannot continue"
    exit 2
fi

SOURCE_BRANCH=$GITHUB_HEAD_REF
TARGET_BRANCH=$GITHUB_BASE_REF

CHECK_TARGET_BRANCH_TMP="INPUT_$(echo $TARGET_BRANCH | awk '{print toupper($0)}')"
CHECK_TARGET_BRANCH=(${!CHECK_TARGET_BRANCH_TMP})

echo -n "Testing $SOURCE_BRANCH -> $TARGET_BRANCH "

if [ -n "${CHECK_TARGET_BRANCH}" ]; then
    for allowed in "${CHECK_TARGET_BRANCH[@]}"; do
        if echo "$SOURCE_BRANCH" | grep -qe "$allowed"; then
            # source branch allowed to merge into target branch
            echo "✔"
            exit 0
        fi
    done
fi

# additionally branches assigned to INPUT_ALL are allowed to merge into all branches
if [ -n "${INPUT_ALL}" ]; then
    INPUT_ALL_ARRAY=(${INPUT_ALL})
    for allowed in "${INPUT_ALL_ARRAY[@]}"; do
        if echo "$SOURCE_BRANCH" | grep -qe "$allowed"; then
            # source branch allowed to merge into all branches
            echo "✔"
            exit 0
        fi
    done
fi

# default case: source branch not permitted to merge to target branch
echo '✘'
exit 1
