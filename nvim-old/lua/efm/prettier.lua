return {
    formatCommand = ([[
        ./node_modules/.bin/prettier
        ${--config-precedence:configPrecedence}
        ${--no-semi:semi}
        ${--single-quote:singleQuote}
        ${--no-bracket-spacing:bracketSpacing}
        ${--trailing-comma:trailingComma}
    ]]):gsub(
        "\n",
        ""
    )
}
