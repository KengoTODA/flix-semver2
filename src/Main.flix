namespace SemVer2 {
  type alias PreRelease = String
  type alias Build = String

  enum SemVer2 with Eq {
    case Standard(Int32, Int32, Int32),
    case WithPreRelease(Int32, Int32, Int32, PreRelease)
    case WithBuild(Int32, Int32, Int32, Build)
    case WithPreReleaseAndBuild(Int32, Int32, Int32, PreRelease, Build)
  }

  @Time(1) @Space(1)
  pub def getMajor(v: SemVer2): Int32 = match v {
    case Standard(x,_,_) => x
    case WithPreRelease(x,_,_,_) => x
    case WithBuild(x,_,_,_) => x
    case WithPreReleaseAndBuild(x,_,_,_,_) => x
  }

  @Time(1) @Space(1)
  pub def getMinor(v: SemVer2): Int32 = match v {
    case Standard(_,y,_) => y
    case WithPreRelease(_,y,_,_) => y
    case WithBuild(_,y,_,_) => y
    case WithPreReleaseAndBuild(_,y,_,_,_) => y
  }

  @Time(1) @Space(1)
  pub def getPatch(v: SemVer2): Int32 = match v {
    case Standard(_,_,z) => z
    case WithPreRelease(_,_,z,_) => z
    case WithBuild(_,_,z,_) => z
    case WithPreReleaseAndBuild(_,_,z,_,_) => z
  }

  @Time(1) @Space(1)
  pub def getPreRelease(v: SemVer2): Option[String] = match v {
    case Standard(_,_,_) => None
    case WithPreRelease(_,_,_,p) => Some(p)
    case WithBuild(_,_,_,_) => None
    case WithPreReleaseAndBuild(_,_,_,p,_) => Some(p)
  }

  @Time(1) @Space(1)
  pub def getBuild(v: SemVer2): Option[String] = match v {
    case Standard(_,_,_)=> None
    case WithPreRelease(_,_,_,_) => None
    case WithBuild(_,_,_,b) => Some(b)
    case WithPreReleaseAndBuild(_,_,_,_,b) => Some(b)
  }

  instance ToString[SemVer2] {
    pub def toString(v: SemVer2): String = match v {
      case Standard(x,y,z) => "${x}.${y}.${z}"
      case WithPreRelease(x,y,z,p) => "${x}.${y}.${z}-${p}"
      case WithBuild(x,y,z,b) => "${x}.${y}.${z}+${b}"
      case WithPreReleaseAndBuild(x,y,z,p,b) => "${x}.${y}.${z}-${p}+${b}"
    }
  }

  def comparePreRelease(l: SemVer2, r: SemVer2): Comparison =
    use Order.compare;

    let lp = getPreRelease(l);
    let rp = getPreRelease(r);
    if (Option.isEmpty(lp) and (not Option.isEmpty(rp))) GreaterThan
    else if (Option.isEmpty(rp) and (not Option.isEmpty(lp))) LessThan
    else Option.getWithDefault("", lp) `compare` Option.getWithDefault("", rp)

  def compareBuild(l: SemVer2, r: SemVer2): Comparison =
    use Order.compare;

    let lb = getBuild(l);
    let rb = getBuild(r);

    if (Option.isEmpty(lb) and (not Option.isEmpty(rb))) GreaterThan
    else if (Option.isEmpty(rb) and (not Option.isEmpty(lb))) LessThan
    else Option.getWithDefault("", lb) `compare` Option.getWithDefault("", rb)

  instance Order[SemVer2] {
    @Time(1) @Space(1)
    pub def compare(l: SemVer2, r: SemVer2): Comparison =
      if      (getMajor(l) != getMajor(r)) Comparison.fromInt32(getMajor(l) - getMajor(r))
      else if (getMinor(l) != getMinor(r)) Comparison.fromInt32(getMinor(l) - getMinor(r))
      else if (getPatch(l) != getPatch(r)) Comparison.fromInt32(getPatch(l) - getPatch(r))
      else if (comparePreRelease(l, r) != EqualTo) comparePreRelease(l, r)
      else compareBuild(l, r)
  }

  def semVer2Body(body: String): Result[List[Int32], String] =
    let split = String.splitOn({substr = "."}, body);
    match List.length(split) {
      case 3 => split |> List.map(Int32.fromString) |> Result.sequence
      case _ => Err("Invalid format (illegal numbers of dots)")
    }

  def map(preRelease: PreRelease, build: Build, l: List[Int32]): Result[SemVer2, String] =
    match l {
      case x :: y :: z :: Nil => Ok(match (preRelease,build) {
        case ("", "") => Standard(x, y, z)
        case (_,  "") => WithPreRelease(x, y, z, preRelease)
        case ("", _)  => WithBuild(x, y, z, build)
        case (_,  _)  => WithPreReleaseAndBuild(x, y, z, preRelease, build)
      })
      case _ => Err("Unreachable")
    }

  pub def parse(string: String): Result[SemVer2, String] =
    let (others, build) = String.breakOnLeft({substr = "+"}, string);
    let (body, preRelease) = String.breakOnLeft({substr = "-"}, others);
    semVer2Body(body) |> Result.flatMap(split: List[Int32] -> {
      split |> map(preRelease |> String.drop(1), build |> String.drop(1))
    })
}
