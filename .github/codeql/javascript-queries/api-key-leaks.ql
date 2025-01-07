import javascript

predicate isApiKeyVariable(Expr e) {
  exists(string value |
    e.getStringValue() = value and
    (
      value.matches("AKIA[0-9A-Z]{16}") or  // AWS API key pattern
      value.matches("AIza[0-9A-Za-z-_]{35}") or  // Google API key pattern
      value.matches("sk_live_[0-9a-zA-Z]{24}")  // Stripe API key pattern
    )
  )
}

from Variable v
where isApiKeyVariable(v.getInitializer())
select v, "This variable appears to contain an API key."