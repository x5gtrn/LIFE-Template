# Privacy Rules

## Do NOT put these into public TIL
- Company/client names, project names, internal code names
- Exact money amounts, invoices, contracts, salaries
- Exact locations, personal schedules, identifiable photos
- Health conditions, medication, mental/medical info
- Relationship details, private messages, IDs, account info
- Anything that can identify a person or an organization

## TIL should be "generalized learnings"
Good:
- "How to configure Spring GraphQL multipart upload"
- "AWS IAM policy pattern for S3 presigned URL"
- "Ruby: pattern matching tips"

Bad:
- "For client X, we solved bug Y in their production"
- "I was sick today and did Z"
- "I went to <place> and met <person>"

## Subtree safety
`vendor/til/` is imported from a public repo.
- Prefer editing TIL in the public repo directly
- Avoid pushing from LIFE to TIL
