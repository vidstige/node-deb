# CHANGELOG

#### unreleased - 2016-03-07
- **BREAKING**
  - `node-deb` will no longer include the `node_modules` directory, but instead will run `npm install` during the
  `postinst` step in the install directory. Thus, if `package.json` exists, it will be auto included in the `.deb`.
- Added
  - Better script logging
