# flix-semver2

A package handling the [semantic versioning v2](https://semver.org/spec/v2.0.0.html).

[![.github/workflows/build.yml](https://github.com/KengoTODA/flix-semver2/actions/workflows/build.yml/badge.svg)](https://github.com/KengoTODA/flix-semver2/actions/workflows/build.yml)
[![semantic-release: angular](https://img.shields.io/badge/semantic--release-angular-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)

# Usage

`SemVer2` is an algebraic data type with the `Eq`, `ToString`, and `Order` type classes.

```flix
use SemVer2.parse;

def isVersion1(text: String): Bool = match parse(text) {
    case Ok(v) => SemVer2.getMajor(v) == 1
    case _ => false
}
```

You can install the fpkg file by the following command:

```console
$ java -jar flix.jar install KengoTODA/flix-semver2
$ ls lib/KengoTODA/flix-semver2/flix-semver2.fpkg
```

# Development

This repository is built with the official Flix jar and pnpm.

```console
$ curl --fail --location --output flix.jar https://github.com/flix/flix/releases/download/v0.73.0/flix.jar
$ echo "5f69225d2e2a5c029abb5a89b306c97e2fe0b2dcb8f51316df9e7ec986811943  flix.jar" | shasum -a 256 --check
$ java -jar flix.jar test
$ java -jar flix.jar build
$ java -jar flix.jar build-pkg
$ corepack enable
$ pnpm install --frozen-lockfile
$ pnpm run compute-hash
```

# Copyright

Copyright &copy; 2022 Kengo TODA all rights reserved.
