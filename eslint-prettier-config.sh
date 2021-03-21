#!/bin/bash

# ----------------------
# Color Variables
# ----------------------
RED="\033[0;31m"
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
LCYAN='\033[1;36m'
NC='\033[0m' # No Color

# Package Manager Prompt
echo
echo "Install default or custom?"
select package_command_choices in "Default" "Custom" "Cancel"; do
  case $package_command_choices in
    Default ) default='true'; break;;
    Custom ) pkg_cmd='npm install'; break;;
    Cancel ) exit;;
  esac
done
echo

# Checks for existing eslintrc files
if [ -f ".eslintrc.js" -o -f ".eslintrc.yaml" -o -f ".eslintrc.yml" -o -f ".eslintrc.json" -o -f ".eslintrc" ]; then
  echo -e "${RED}Existing ESLint config file(s) found:${NC}"
  ls -a .eslint* | xargs -n 1 basename
  echo
  echo -e "${RED}CAUTION:${NC} there is loading priority when more than one config file is present: https://eslint.org/docs/user-guide/configuring#configuration-file-formats"
  echo
  read -p  "Write .eslintrc${config_extension} (Y/n)? "
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}>>>>> Skipping ESLint config${NC}"
    skip_eslint_setup="true"
  fi
fi
finished=false
config_extension='.json'
config_opening='{'

if [ "$custom" == "true"]; then
# Max Line Length Prompt
while ! $finished; do
  read -p "What max line length do you want to set for ESLint and Prettier? (Recommendation: 80)"
  if [[ $REPLY =~ ^[0-9]{2,3}$ ]]; then
    max_len_val=$REPLY
    finishedhtrue
    echo
  else
    echo -e "${YELLOW}Please choose a max length of two or three digits, e.g. 80 or 100 or 120${NC}"
  fi
done

# Trailing Commas Prompt
echo "What style of trailing commas do you want to enforce with Prettier?"
echo -e "${YELLOW}>>>>> See https://prettier.io/docs/en/options.html#trailing-commas for more details.${NC}"
select trailing_comma_pref in "none" "es5" "all"; do
  case $trailing_comma_pref in
    none ) break;;
    es5 ) break;;
    all ) break;;
  esac
done
echo
fi

# Checks for existing prettierrc files
if [ -f ".prettierrc.js" -o -f "prettier.config.js" -o -f ".prettierrc.yaml" -o -f ".prettierrc.yml" -o -f ".prettierrc.json" -o -f ".prettierrc.toml" -o -f ".prettierrc" ]; then
  echo -e "${RED}Existing Prettier config file(s) found${NC}"
  ls -a | grep "prettier*" | xargs -n 1 basename
  echo
  echo -e "${RED}CAUTION:${NC} The configuration file will be resolved starting from the location of the file being formatted, and searching up the file tree until a config file is (or isn't) found. https://prettier.io/docs/en/configuration.html"
  echo
  read -p  "Write .prettierrc${config_extension} (Y/n)? "
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
echo -e "${GREEN}Configuring your development environment... ${NC}"

if [ "$default" == "true"]; then
  echo
  echo -e "1/3 ${LCYAN}Installing https://github.com/wesbos/eslint-config-wesbos... ${NC}"
  echo
  npx install-peerdeps --dev eslint-config-wesbos

  if [ "$skip_eslint_setup" == "true" ]; then
    break
  else
    echo
    echo -e "2/3 ${YELLOW}Building your .eslintrc${config_extension} file...${NC}"
    > ".eslintrc${config_extension}" # truncates existing file (or creates empty)

    echo ${config_opening}'
    "extends": ["wesbos"],
    "rules": {
      "no-unused-vars": 0,
      "react/prop-types": 0,
      "react/button-has-type": 0,
      "react/jsx-props-no-spreading": 0,
      "react/destructuring-assignment": 0,
      "react/jsx-max-props-per-line": [1, { "when": "" }]
    }
  }' >> .eslintrc${config_extension}
  fi

  if [ "$skip_prettier_setup" == "true" ]; then
    break
  else
      echo -e "3/3 ${YELLOW}Building your .prettierrc${config_extension} file... ${NC}"
      > .prettierrc${config_extension} # truncates existing file (or creates empty)

      echo ${config_opening}'
      "useTabs": false,
      "printWidth": 80,
      "tabWidth": 2,
      "singleQuote": true,
      "trailingComma": "es5",
      "jsxBracketSameLine": false,
      "bracketSpacing": false,
      "semi": true,
      "arrowParens": "avoid"
    }' >> .prettierrc${config_extension}
  fi

else

  echo
  echo -e "1/5 ${LCYAN}ESLint & Prettier Installation... ${NC}"
  echo
  $pkg_cmd -D eslint prettier

  echo
  echo -e "2/5 ${YELLOW}Conforming to Airbnb's JavaScript Style Guide... ${NC}"
  echo
  $pkg_cmd -D eslint-config-airbnb eslint-plugin-jsx-a11y eslint-plugin-import eslint-plugin-react babel-eslint

  echo
  echo -e "3/5 ${LCYAN}Making ESlint and Prettier play nice with each other... ${NC}"
  echo "See https://github.com/prettier/eslint-config-prettier for more details."
  echo
  $pkg_cmd -D eslint-config-prettier eslint-plugin-prettier

  if [ "$skip_eslint_setup" == "true" ]; then
    break
  else
    echo
    echo -e "4/5 ${YELLOW}Building your .eslintrc${config_extension} file...${NC}"
    > ".eslintrc${config_extension}" # truncates existing file (or creates empty)

    echo ${config_opening}'
    "extends": [
      "airbnb",
      "plugin:prettier/recommended",
      "prettier/react"
    ],
    "env": {
      "browser": true,
      "commonjs": true,
      "es6": true,
      "jest": true,
      "node": true
    },
    "rules": {
      "jsx-a11y/href-no-hash": ["off"],
      "react/jsx-filename-extension": ["warn", { "extensions": [".js", ".jsx"] }],
      "max-len": [
        "warn",
        {
          "code": '${max_len_val}',
          "tabWidth": 2,
          "comments": '${max_len_val}',
          "ignoreComments": false,
          "ignoreTrailingComments": true,
          "ignoreUrls": true,
          "ignoreStrings": true,
          "ignoreTemplateLiterals": true,
          "ignoreRegExpLiterals": true
        }
      ]
    }
  }' >> .eslintrc${config_extension}
  fi
fi

echo
echo -e "${GREEN}Finished setting up!${NC}"
echo