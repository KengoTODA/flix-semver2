import { createReadStream, writeFileSync } from "fs";
import { createHash } from "crypto";

function computeHash(
  path: string
): Promise<{ sha512: string; sha256: string }> {
  return new Promise((resolve, reject) => {
    const sha256 = createHash("sha256");
    const sha512 = createHash("sha512");
    const r = createReadStream(path);
    r.on("data", () => {
      const data = r.read();
      if (data) {
        sha256.update(data);
        sha512.update(data);
      } else {
        resolve({ sha256: sha256.digest("hex"), sha512: sha512.digest("hex") });
      }
    });
    r.on("error", (e) => {
      reject(e);
    });
  });
}

const filename = 'flix-semver2.fpkg';
computeHash(filename).then(({sha256, sha512}) => {
    writeFileSync(`${filename}.sha256`, sha256);
    writeFileSync(`${filename}.sha512`, sha512);
});
