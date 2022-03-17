# flix-semver2

A package handling the [semantic versioning v2](https://semver.org/spec/v2.0.0.html).

[![.github/workflows/build.yml](https://github.com/KengoTODA/flix-semver2/actions/workflows/build.yml/badge.svg)](https://github.com/KengoTODA/flix-semver2/actions/workflows/build.yml)
[![semantic-release: angular](https://img.shields.io/badge/semantic--release-angular-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)

# Usage

`SemVer2` is an algebraic data type with the [`Eq` type class](https://github.com/flix/flix/blob/v0.26.0/main/src/library/Eq.flix), [`ToString` type class](https://github.com/flix/flix/blob/v0.26.0/main/src/library/ToString.flix), and [`Order` type class](https://github.com/flix/flix/blob/v0.26.0/main/src/library/Order.flix).

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

# Copyright

Copyright &copy; 2022 Kengo TODA all rights reserved.
