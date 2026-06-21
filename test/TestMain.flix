use SemVer2.parse;

@CompileTest
def testMajor(): Bool =
  match parse("1.2.3-alpha+001") {
      case Ok(v) => SemVer2.getMajor(v) == 1
      case _ => false
  }

@CompileTest
def testMinor(): Bool =
  match parse("1.2.3-alpha+001") {
      case Ok(v) => SemVer2.getMinor(v) == 2
      case _ => false
  }

@CompileTest
def testPatch(): Bool =
  match parse("1.2.3-alpha+001") {
    case Ok(v) => SemVer2.getPatch(v) == 3
    case _ => false
  }

@CompileTest
def testPreRelease(): Bool =
  match parse("1.2.3-alpha+001") {
    case Ok(v) => match SemVer2.getPreRelease(v) {
        case Some(p) => p == "alpha"
        case _ => false
    }
    case _ => false
  }

@CompileTest
def testBuild(): Bool =
  match parse("1.2.3-alpha+001") {
    case Ok(v) => match SemVer2.getBuild(v) {
        case Some(p) => p == "001"
        case _ => false
    }
    case _ => false
  }

@CompileTest
def testLessDots(): Bool =
  match parse("1.2-alpha+001") {
    case Ok(_v) => false
    case Err(s) => s == "Invalid format (illegal numbers of dots)"
  }

@CompileTest
def testManyDots(): Bool =
  match parse("1.2.3.4-alpha+001") {
    case Ok(_v) => false
    case Err(s) => s == "Invalid format (illegal numbers of dots)"
  }

@CompileTest
def testNotNumericMajor(): Bool =
  match parse("foo.2.3-alpha+001") {
    case Ok(_v) => false
    case Err(s) => s == "Int32.fromString"
  }

@CompileTest
def testToString01(): Bool =
  match parse("1.2.3") {
    case Ok(v) => "${v}" == "1.2.3"
    case Err(_) => false
  }

@CompileTest
def testToString02(): Bool =
  match parse("1.2.3-beta.1") {
    case Ok(v) => "${v}" == "1.2.3-beta.1"
    case Err(_) => false
  }
 
@CompileTest
def testToString03(): Bool =
  match parse("1.2.3+001") {
    case Ok(v) => "${v}" == "1.2.3+001"
    case Err(_) => false
  }

@CompileTest
def testToString04(): Bool =
  match parse("1.2.3-rc+001") {
    case Ok(v) => "${v}" == "1.2.3-rc+001"
    case Err(_) => false
  }

@CompileTest
def testEq01(): Bool =
  match (parse("1.2.3"), parse("1.2.3")) {
    case (Ok(l), Ok(r)) => l == r
    case _ => false
  }

@CompileTest
def testEq02(): Bool =
  match (parse("1.2.3-rc.1"), parse("1.2.3")) {
    case (Ok(l), Ok(r)) => l != r
    case _ => false
  }

@CompileTest
def testEq03(): Bool =
  match (parse("1.2.3-rc.1"), parse("1.2.3-rc.2")) {
    case (Ok(l), Ok(r)) => l != r
    case _ => false
  }

@CompileTest
def testCompare00(): Bool =
  match (parse("2.2.3"), parse("1.2.3")) {
    case (Ok(l), Ok(r)) => l > r
    case _ => false
  }

@CompileTest
def testCompare01(): Bool =
  match (parse("1.2.3"), parse("1.2.4")) {
    case (Ok(l), Ok(r)) => l < r
    case _ => false
  }

@CompileTest
def testCompare02(): Bool =
  match (parse("1.2.3"), parse("1.3.0")) {
    case (Ok(l), Ok(r)) => l < r
    case _ => false
  }

@CompileTest
def testCompare03(): Bool =
  match (parse("1.2.3"), parse("2.0.0")) {
    case (Ok(l), Ok(r)) => l < r
    case _ => false
  }

@CompileTest
def testCompare04(): Bool =
  match (parse("1.2.3-beta"), parse("1.2.3")) {
    case (Ok(l), Ok(r)) => l < r
    case _ => false
  }

@CompileTest
def testCompare05(): Bool =
  match (parse("1.2.3"), parse("1.2.3-beta")) {
    case (Ok(l), Ok(r)) => l > r
    case _ => false
  }

@CompileTest
def testCompare06(): Bool =
  match (parse("1.2.3-alpha"), parse("1.2.3-beta")) {
    case (Ok(l), Ok(r)) => l < r
    case _ => false
  }

@CompileTest
def testCompare07(): Bool =
  match (parse("1.2.3-beta.1"), parse("1.2.3-beta.2")) {
    case (Ok(l), Ok(r)) => l < r
    case _ => false
  }

@CompileTest
def testCompare08(): Bool =
  match (parse("1.2.3"), parse("1.2.3")) {
    case (Ok(l), Ok(r)) => l <= r
    case _ => false
  }
