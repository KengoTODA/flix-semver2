use SemVer2.parse;

@test
def testMajor(): Bool =
  match parse("1.2.3-alpha+001") {
      case Ok(v) => SemVer2.getMajor(v) == 1
      case _ => false
  }

@test
def testMinor(): Bool =
  match parse("1.2.3-alpha+001") {
      case Ok(v) => SemVer2.getMinor(v) == 2
      case _ => false
  }

@test
def testPatch(): Bool =
  match parse("1.2.3-alpha+001") {
    case Ok(v) => SemVer2.getPatch(v) == 3
    case _ => false
  }

@test
def testPreRelease(): Bool =
  match parse("1.2.3-alpha+001") {
    case Ok(v) => match SemVer2.getPreRelease(v) {
        case Some(p) => p == "alpha"
        case _ => false
    }
    case _ => false
  }

@test
def testBuild(): Bool =
  match parse("1.2.3-alpha+001") {
    case Ok(v) => match SemVer2.getBuild(v) {
        case Some(p) => p == "001"
        case _ => false
    }
    case _ => false
  }

@test
def testLessDots(): Bool =
  match parse("1.2-alpha+001") {
    case Ok(_v) => false
    case Err(s) => s == "Invalid format (illegal numbers of dots)"
  }

@test
def testManyDots(): Bool =
  match parse("1.2.3.4-alpha+001") {
    case Ok(_v) => false
    case Err(s) => s == "Invalid format (illegal numbers of dots)"
  }

@test
def testNotNumericMajor(): Bool =
  match parse("foo.2.3-alpha+001") {
    case Ok(_v) => false
    case Err(s) => s == "Int32.fromString"
  }

@test
def testToString01(): Bool =
  match parse("1.2.3") {
    case Ok(v) => "${v}" == "1.2.3"
    case Err(_) => false
  }

@test
def testToString02(): Bool =
  match parse("1.2.3-beta.1") {
    case Ok(v) => "${v}" == "1.2.3-beta.1"
    case Err(_) => false
  }
 
@test
def testToString03(): Bool =
  match parse("1.2.3+001") {
    case Ok(v) => "${v}" == "1.2.3+001"
    case Err(_) => false
  }

@test
def testToString04(): Bool =
  match parse("1.2.3-rc+001") {
    case Ok(v) => "${v}" == "1.2.3-rc+001"
    case Err(_) => false
  }

@test
def testEq01(): Bool = {
    use Result.flatMap;
    let* l = parse("1.2.3");
    let* r = parse("1.2.3");
    Ok(l == r)
  } |> Result.getWithDefault(false)

@test
def testEq02(): Bool = {
    use Result.flatMap;
    let* l = parse("1.2.3-rc.1");
    let* r = parse("1.2.3");
    Ok(l != r)
  } |> Result.getWithDefault(false)

@test
def testEq03(): Bool = {
    use Result.flatMap;
    let* l = parse("1.2.3-rc.1");
    let* r = parse("1.2.3-rc.2");
    Ok(l != r)
  } |> Result.getWithDefault(false)

@test
def testCompare00(): Bool = {
    use Result.flatMap;
    let* l = parse("2.2.3");
    let* r = parse("1.2.3");
    Ok(l > r)
  } |> Result.getWithDefault(false)

@test
def testCompare01(): Bool = {
    use Result.flatMap;
    let* l = parse("1.2.3");
    let* r = parse("1.2.4");
    Ok(l < r)
  } |> Result.getWithDefault(false)

@test
def testCompare02(): Bool = {
    use Result.flatMap;
    let* l = parse("1.2.3");
    let* r = parse("1.3.0");
    Ok(l < r)
  } |> Result.getWithDefault(false)

@test
def testCompare03(): Bool = {
    use Result.flatMap;
    let* l = parse("1.2.3");
    let* r = parse("2.0.0");
    Ok(l < r)
  } |> Result.getWithDefault(false)

@test
def testCompare04(): Bool = {
    use Result.flatMap;
    let* l = parse("1.2.3-beta");
    let* r = parse("1.2.3");
    Ok(l < r)
  } |> Result.getWithDefault(false)

@test
def testCompare05(): Bool = {
    use Result.flatMap;
    let* l = parse("1.2.3");
    let* r = parse("1.2.3-beta");
    Ok(l > r)
  } |> Result.getWithDefault(false)

@test
def testCompare06(): Bool = {
    use Result.flatMap;
    let* l = parse("1.2.3-alpha");
    let* r = parse("1.2.3-beta");
    Ok(l < r)
  } |> Result.getWithDefault(false)

@test
def testCompare07(): Bool = {
    use Result.flatMap;
    let* l = parse("1.2.3-beta.1");
    let* r = parse("1.2.3-beta.2");
    Ok(l < r)
  } |> Result.getWithDefault(false)

@test
def testCompare08(): Bool = {
    use Result.flatMap;
    let* l = parse("1.2.3");
    let* r = parse("1.2.3");
    Ok(l <= r)
  } |> Result.getWithDefault(false)
