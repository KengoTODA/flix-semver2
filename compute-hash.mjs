import { createReadStream, writeFileSync } from "node:fs";
import { createHash } from "node:crypto";

function computeHash(path) {
  return new Promise((resolve, reject) => {
    const sha256 = createHash("sha256");
    const sha512 = createHash("sha512");
    const stream = createReadStream(path);

    stream.on("data", (data) => {
      sha256.update(data);
      sha512.update(data);
    });
    stream.on("end", () => {
      resolve({
        sha256: sha256.digest("hex"),
        sha512: sha512.digest("hex"),
      });
    });
    stream.on("error", reject);
  });
}

const filename = process.argv[2] ?? "flix-semver2.fpkg";
const { sha256, sha512 } = await computeHash(filename);

writeFileSync(`${filename}.sha256`, `${sha256}\n`);
writeFileSync(`${filename}.sha512`, `${sha512}\n`);
