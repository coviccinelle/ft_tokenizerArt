# On-Chain SVG (Short Guide)

Keep-on-chain SVGs short, simple, and gas-aware. Below are the essentials you need to implement and test SVGs embedded in a contract.

Key points
- Store small SVGs (prefer < 2–3 KB) to keep gas reasonable.
- Prefer simple shapes, solid fills, and minimal path/text complexity.
- Use base64 data URIs for compatibility, or plain data URIs for slightly smaller size.

Minimal Solidity pattern (string constant + Base64):
```solidity
import "@openzeppelin/contracts/utils/Base64.sol";

string constant BONUS_SVG = "<svg xmlns='http://www.w3.org/2000/svg' width='400' height='400'>...<text>42</text></svg>";

function svgDataURI() internal pure returns (string memory) {
  return string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(bytes(BONUS_SVG))));
}
```

Why base64?
- Solidity strings are binary-safe but embedding raw SVG text directly into JSON or a data URI can introduce characters that break JSON or require extra escaping (quotes, newlines, characters with special meaning).
- Base64 encodes binary/text into a safe, compact ASCII string that can be embedded inside JSON and data URIs without additional escaping.
- Many on-chain examples wrap the SVG in a base64 `data:image/svg+xml;base64,...` so wallets and marketplaces can decode and render the image reliably.

Simple relation (how things fit together)

tokenURI(uint256 id)
  → returns metadata (string)
    - metadata is usually JSON (either hosted off-chain or embedded as a data URI)
    - JSON contains fields like `name`, `description`, and `image`
      - `image` can be:
        - an IPFS/HTTP URL (off-chain host)
        - a data URI: `data:image/svg+xml;base64,<base64_svg>` (on-chain SVG)

Flow examples
- On-chain SVG: tokenURI returns `data:application/json;base64,<base64(JSON)>` where the JSON's `image` value is `data:image/svg+xml;base64,<base64(SVG)>`.
- Off-chain SVG: tokenURI returns `ipfs://<hash>/tokenId.json` and that JSON's `image` is `ipfs://<svg-hash>`.

Testing tips
- Unit test: mint and call tokenURI(), assert the returned string starts with `data:image/svg+xml`.
- Browser: paste a data URI into an <img> to preview.

Optimization
- Remove whitespace and comments; simplify paths; reuse shapes.
- Consider URL-encoded data URIs (no base64) if they save bytes for your SVG.

Resources
- SVG optimization: https://web.dev/optimize-svgs/
- Base64 helper: OpenZeppelin Base64
- On-chain patterns: https://github.com/w1nt3r-eth/hot-chain-svg

That's it — start small, measure gas, then iterate.
