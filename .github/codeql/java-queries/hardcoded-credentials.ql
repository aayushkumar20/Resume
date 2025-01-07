import java

/**
 * Detect hardcoded credentials in Java code.
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
select assign, "Hardcoded credentials found in Java code."