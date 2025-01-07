import python

/**
 * Detects sensitive information such as passwords, API keys, and tokens
 * being assigned or logged in the code.
 */
predicate isSensitiveValue(Expr e) {
  exists(string value |
    e.getStringValue() = value and
    (
      value.matches(".*password.*", "i") or
      value.matches(".*secret.*", "i") or
      value.matches(".*key.*", "i") or
      value.matches(".*token.*", "i")
    )
  )
}

from CallExpr call
where isSensitiveValue(call.getArgument(0))
select call, "Sensitive information found in function call argument."