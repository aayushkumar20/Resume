import go

/**
 * Detect sensitive data like API keys and passwords in Go source code.
 */
predicate isSensitiveData(string value) {
  value.matches("AKIA[0-9A-Z]{16}") or   // AWS API key
  value.matches("AIza[0-9A-Za-z-_]{35}") or // Google API key
  value.matches("sk_live_[0-9a-zA-Z]{24}") // Stripe API key
}

from StringLiteral lit
where isSensitiveData(lit.getStringValue())
select lit, "This string literal contains sensitive data (API key, password, etc.)."