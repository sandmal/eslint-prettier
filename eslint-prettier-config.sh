#!/bin/bash

# ----------------------
# Color Variables
# ----------------------
RED="\033[0;31m"
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
LCYAN='\033[1;36m'
NC='\033[0m' # No Color

# Checks for existing eslintrc files
if [ -f ".eslintrc.js" -o -f ".eslintrc.yaml" -o -f ".eslintrc.yml" -o -f ".eslintrc.json" -o -f ".eslintrc" ]; then
  echo -e "${RED}Existing ESLint config file(s) found:${NC}"
  ls -a .eslint* | xargs -n 1 basename
  echo
  echo -e "${RED}CAUTION:${NC} there is loading priority when more than one config file is present: https://eslint.org/docs/user-guide/configuring#configuration-file-formats"
  echo
  read -p  "Write .eslintrc.json (Y/n)? "
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}>>>>> Skipping ESLint config${NC}"
    skip_eslint_setup="true"
  fi
fi
finished=false

# Checks for existing prettierrc files
if [ -f ".prettierrc.js" -o -f "prettier.config.js" -o -f ".prettierrc.yaml" -o -f ".prettierrc.yml" -o -f ".prettierrc.json" -o -f ".prettierrc.toml" -o -f ".prettierrc" ]; then
  echo -e "${RED}Existing Prettier config file(s) found${NC}"
  ls -a | grep "prettier*" | xargs -n 1 basename
  echo
  echo -e "${RED}CAUTION:${NC} The configuration file will be resolved starting from the location of the file being formatted, and searching up the file tree until a config file is (or isn't) found. https://prettier.io/docs/en/configuration.html"
  echo
  read -p  "Write .prettierrc (Y/n)? "
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}>>>>> Skipping Prettier config${NC}"
    skip_prettier_setup="true"
  fi
  echo
fi

# ----------------------
# Perform Configuration
# ----------------------

echo
echo -e "${GREEN}Configuring development environment... ${NC}"

echo
echo -e "1/3 ${LCYAN}Installing https://github.com/wesbos/eslint-config-wesbos... ${NC}"
echo
npx install-peerdeps --dev eslint-config-wesbos

if [ "$skip_eslint_setup" == "true" ]; then
  break
else
  echo
  echo -e "2/3 ${YELLOW}Building your .eslintrc.json file...${NC}"
  > ".eslintrc.json" # truncates existing file (or creates empty)

  echo "{ "'
      "extends": ["wesbos"],
      "rules": {
      "no-unused-vars": 0,
      "react/prop-types": 0,
      "react/button-has-type": 0,
      "react/jsx-props-no-spreading": 0,
      "react/destructuring-assignment": 0,
      "react/jsx-max-props-per-line": [1, { "when": "multiline" }]
     }
}' >> .eslintrc.json
fi

if [ "$skip_prettier_setup" == "true" ]; then
  break
else
  echo -e "3/3 ${YELLOW}Building .prettierrc.json file... ${NC}"
  > .prettierrc.json # truncates existing file (or creates empty)

  echo "{"'
    "useTabs": false,
    "printWidth": 80,
    "tabWidth": 2,
    "singleQuote": true,
    "trailingComma": "es5",
    "jsxBracketSameLine": false,
    "bracketSpacing": false,
    "semi": true,
    "arrowParens": "avoid"
}' >> .prettierrc.json
fi

echo
echo -e "Add this under script inside package.json"
echo
echo -e "\"lint\"": \""eslint ."\",""
echo -e "\"lint:fix\"": \""eslint . --fix"\""";
echo
echo -e "${GREEN}Finished setting up!${NC}"
echo
