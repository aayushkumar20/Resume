import csharp

/**
 * Detect hardcoded credentials in C# code such as passwords or API keys.
 */
predicate isHardcodedCredential(Expr e) {
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

from AssignExpr assign
where isHardcodedCredential(assign.getRightOperand())
select assign, "Hardcoded credentials found in C# code."