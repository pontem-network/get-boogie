# Get Boogie Action

This GitHub Action delivers dependencies needed for [`dove`] `prove` - Z3 and Boogie.

[`dove`]: https://github.com/pontem-network/dove


## Parameters

- `token` - GITHUB_TOKEN. Optional.
- `ref` - Branch or commit pointing to pontem-network/move repo. Read it as version of installer. Default is `main`.


## Usage Example

Download Boogie using latest version of installer

```yaml
- name: get boogie
  uses: pontem-network/get-boogie@main
```

Use a specific version of installer, with token

```yaml
- name: get boogie
  uses: pontem-network/get-boogie@main
  with:
    ref: 927c229cd8dfa6dcd50ba84811f80d10496c76d2
    token: ${{ secrets.GITHUB_TOKEN }}
```
