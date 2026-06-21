use SemVer2.parse;
use Assert.assertTrue;

def check(condition: Bool): Unit \ Assert =
  assertTrue(condition)

@Test
def testMajor(): Unit \ Assert =
  check(match parse("1.2.3-alpha+001") {
    case Ok(v) => SemVer2.getMajor(v) == 1
    case _ => false
  })

@Test
def testMinor(): Unit \ Assert =
  check(match parse("1.2.3-alpha+001") {
    case Ok(v) => SemVer2.getMinor(v) == 2
    case _ => false
  })

@Test
def testPatch(): Unit \ Assert =
  check(match parse("1.2.3-alpha+001") {
    case Ok(v) => SemVer2.getPatch(v) == 3
    case _ => false
  })

@Test
def testPreRelease(): Unit \ Assert =
  check(match parse("1.2.3-alpha+001") {
    case Ok(v) => match SemVer2.getPreRelease(v) {
      case Some(p) => p == "alpha"
      case _ => false
    }
    case _ => false
  })

@Test
def testBuild(): Unit \ Assert =
  check(match parse("1.2.3-alpha+001") {
    case Ok(v) => match SemVer2.getBuild(v) {
      case Some(p) => p == "001"
      case _ => false
    }
    case _ => false
  })

@Test
def testLessDots(): Unit \ Assert =
  check(match parse("1.2-alpha+001") {
    case Ok(_v) => false
    case Err(s) => s == "Invalid format (illegal numbers of dots)"
  })

@Test
def testManyDots(): Unit \ Assert =
  check(match parse("1.2.3.4-alpha+001") {
    case Ok(_v) => false
    case Err(s) => s == "Invalid format (illegal numbers of dots)"
  })

@Test
def testNotNumericMajor(): Unit \ Assert =
  check(match parse("foo.2.3-alpha+001") {
    case Ok(_v) => false
    case Err(s) => s == "Int32.fromString"
  })

@Test
def testToString01(): Unit \ Assert =
  check(match parse("1.2.3") {
    case Ok(v) => "${v}" == "1.2.3"
    case Err(_) => false
  })

@Test
def testToString02(): Unit \ Assert =
  check(match parse("1.2.3-beta.1") {
    case Ok(v) => "${v}" == "1.2.3-beta.1"
    case Err(_) => false
  })

@Test
def testToString03(): Unit \ Assert =
  check(match parse("1.2.3+001") {
    case Ok(v) => "${v}" == "1.2.3+001"
    case Err(_) => false
  })

@Test
def testToString04(): Unit \ Assert =
  check(match parse("1.2.3-rc+001") {
    case Ok(v) => "${v}" == "1.2.3-rc+001"
    case Err(_) => false
  })

@Test
def testEq01(): Unit \ Assert =
  check(match (parse("1.2.3"), parse("1.2.3")) {
    case (Ok(l), Ok(r)) => l == r
    case _ => false
  })

@Test
def testEq02(): Unit \ Assert =
  check(match (parse("1.2.3-rc.1"), parse("1.2.3")) {
    case (Ok(l), Ok(r)) => l != r
    case _ => false
  })

@Test
def testEq03(): Unit \ Assert =
  check(match (parse("1.2.3-rc.1"), parse("1.2.3-rc.2")) {
    case (Ok(l), Ok(r)) => l != r
    case _ => false
  })

@Test
def testCompare00(): Unit \ Assert =
  check(match (parse("2.2.3"), parse("1.2.3")) {
    case (Ok(l), Ok(r)) => l > r
    case _ => false
  })

@Test
def testCompare01(): Unit \ Assert =
  check(match (parse("1.2.3"), parse("1.2.4")) {
    case (Ok(l), Ok(r)) => l < r
    case _ => false
  })

@Test
def testCompare02(): Unit \ Assert =
  check(match (parse("1.2.3"), parse("1.3.0")) {
    case (Ok(l), Ok(r)) => l < r
    case _ => false
  })

@Test
def testCompare03(): Unit \ Assert =
  check(match (parse("1.2.3"), parse("2.0.0")) {
    case (Ok(l), Ok(r)) => l < r
    case _ => false
  })

@Test
def testCompare04(): Unit \ Assert =
  check(match (parse("1.2.3-beta"), parse("1.2.3")) {
    case (Ok(l), Ok(r)) => l < r
    case _ => false
  })

@Test
def testCompare05(): Unit \ Assert =
  check(match (parse("1.2.3"), parse("1.2.3-beta")) {
    case (Ok(l), Ok(r)) => l > r
    case _ => false
  })

@Test
def testCompare06(): Unit \ Assert =
  check(match (parse("1.2.3-alpha"), parse("1.2.3-beta")) {
    case (Ok(l), Ok(r)) => l < r
    case _ => false
  })

@Test
def testCompare07(): Unit \ Assert =
  check(match (parse("1.2.3-beta.1"), parse("1.2.3-beta.2")) {
    case (Ok(l), Ok(r)) => l < r
    case _ => false
  })

@Test
def testCompare08(): Unit \ Assert =
  check(match (parse("1.2.3"), parse("1.2.3")) {
    case (Ok(l), Ok(r)) => l <= r
    case _ => false
  })
