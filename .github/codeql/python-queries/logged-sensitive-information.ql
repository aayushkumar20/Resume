import python

/**
 * Detect sensitive information (e.g., API keys, passwords) being logged
 * in Python applications.
 */
predicate isSensitiveLoggedInfo(CallExpr call) {
  exists(Expr arg |
    arg = call.getArgument(0) and
    exists(string value |
      arg.getStringValue() = value and
      (
        value.matches(".*password.*", "i") or
        value.matches(".*secret.*", "i") or
        value.matches(".*key.*", "i") or
        value.matches(".*token.*", "i")
      )
    )
  )
}

from CallExpr logCall
where logCall.getTarget().getName() = "print" and isSensitiveLoggedInfo(logCall)
select logCall, "Sensitive information logged in Python code."