module.exports = {
    "env": {
        "browser": true,
        "commonjs": true,
        "es6": true,
        "node": true,
        "jest/globals": true
    },
    "extends": [
      "eslint:recommended",
      "plugin:meteor/recommended"
    ],
    "parserOptions": {
    "ecmaFeatures": {
        "experimentalObjectRestSpread": true,
        "jsx": true
    },
    "sourceType": "module"
    },
    "plugins": [
        "react",
        "jest"
    ],
    "globals": {
        "$": true,
        "Npm": true,
        "_": true,
        "jQuery": true,
        "moment": true,
        "Meteor": true,
        "Template": true,
        "React": true
      },
    "rules": {
        "react/jsx-uses-react": "error",
        "react/jsx-uses-vars": "error",
        "no-console": 0,
        "indent": [
            "error",
            2
        ],
        "linebreak-style": [
            "error",
            "unix"
        ],
        "quotes": [
            "error",
            "single"
        ],
        "semi": [
            "error",
            "always"
        ]
    }
};
