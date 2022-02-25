# Contributing

All contributors are welcome to submit patches but please keep the following in mind:

- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Prerequisites](#prerequisites)

Please also keep in mind:

- Please be patient, I'm only one person with a full time job
- Please be receptive and responsive to feedback about your additions or changes. This is part of the review process, and helps everyone to understand what is happening, why it is happening, and potentially optimizes your code.
- Please be understanding

If you're looking to contribute but aren't sure where to start, check out the open issues.

## Will Not Merge

This details Pull Requests that we will **not** be merged.

- New features without accompanying tests or proof of operation
- New features without accompanying usage documentation

## Coding Standards

The submitted code should be compatible with the following standards

- 2-space indentation style
- First curl brace on the same line as the method
- Closing curl brace on its own aligned newline
- Variable and value assignment does not need to be aligned with assignment operator
- Where possible, avoid HEREDOC in favor of script or templates

## Testing

Please indicate the results of your tests in a comment along with the pull request. Supplying tests and the method used to run/validate the changes are highly encouraged.

## Prerequisites

Familiarize yourself with Terraform and be well versed in its interpolations.

- [Terraform docs](https://www.terraform.io/docs)

Familiarize yourself with Vault documentation.

- [Vault](https://www.vaultproject.io/)
- [Vault docs](https://www.vaultproject.io/docs)

## Process

1. Fork the git repository from GitHub:
2. Create a branch for your changes:

        git checkout -b my_bug_fix

3. Make any changes
4. Write tests to support those changes.
5. Run the tests:
6. Assuming the tests pass, open a Pull Request on GitHub and add results

## Do's and Don't's

- **Do** include tests for your contribution or operational proof
- **Do** request feedback via GitHub issues or other contact
- **Do NOT** break existing behavior (unless intentional)
- **Do NOT** modify the documentation
