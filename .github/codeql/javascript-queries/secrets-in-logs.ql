import javascript

/**
 * Detect secrets such as API keys and tokens being logged to the console.
 */
predicate isSensitiveLogArgument(Expr e) {
  exists(string value |
    e.getStringValue() = value and
    (
      value.matches("AKIA[0-9A-Z]{16}") or // AWS API key pattern
      value.matches("AIza[0-9A-Za-z-_]{35}") or // Google API key pattern
      value.matches("sk_live_[0-9a-zA-Z]{24}") // Stripe API key pattern
    )
  )
}

from CallExpr call
where call.getTarget().getName() = "console.log" and isSensitiveLogArgument(call.getArgument(0))
select call, "Sensitive information logged in console."