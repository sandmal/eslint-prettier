# Installation

1. Navigate to directory

```bash
cd my-app
```

2. Run this command inside root dir. Note: this wont clone the whole repo to local machine

```bash
exec 3<&1;bash <&3 <(curl https://raw.githubusercontent.com/sandmal/eslint-prettier/master/eslint-prettier-config.sh 2> /dev/null)
```

3. Add this inside package.json under scrips

```bash
  "lint": "eslint .",
  "lint:fix": "eslint . --fix"
```

## Intented for own use

I'm tierd of copy pasting the same eslint, prettier config for everyprosject. So this is going to save a lot of time in the future.

Inspired by pauloramos and wesbos

### Credit

All credits goes to Paulo Ramos and Wes Bos.

Paulo ramos @ https://github.com/paulolramos/eslint-prettier-airbnb-react

Wes Bos @ https://github.com/wesbos/eslint-config-wesbos
