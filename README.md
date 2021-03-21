# Installation

1. Navigate to directory

```bash
cd my-app
```

2. Run this command inside root dir. Note: this wont clone the whole repo to local machine

```bash
exec 3<&1;bash <&3 <(curl https://raw.githubusercontent.com/sandmal/eslint-prettier/master/eslint-prettier-config.sh 2> /dev/null)
```

3. IF you choose custom you can change max-line size (80, 100, 120) and trailing commas (none, es5, all)

4. look in project root dir, notice configs

```bash
.eslint.json
.prettierrc.json
```
