# nextflow-language-server.nix

This is a Nix flake for the wonderful [Nextflow language server](https://github.com/nextflow-io/language-server).

I am consuming it via Nix Home Manager.  [Here's the commit](https://github.com/tesujimath/home.nix/commit/3d62ef32672042aac7dfe319d71cfbed90c68819) in which I added use of this flake to my Home Manager config, including configuring support for [Helix](https://helix-editor.com/).

I am currently soliciting interest in merging this into the main [Nextflow language server](https://github.com/nextflow-io/language-server) repo, in which case this separate repo will become redundant.

## Maintainence of gradle.lock

When the language server dependencies are updated, the `gradle.lock` file in this repo will need to be updated also.  In the main language server repo, the following commands will generate the lock file, which can be copied here (requires Nix with flakes support, and `openjdk-21` already being available in the Nix store):

```
$ export JAVA_HOME=$(ls -d /nix/store/*-openjdk-21* | grep -v '.drv$' | sort -V | tail -n1)

$ nix run github:tadfisher/gradle2nix/v2 -- -t build
```

Note: requires [gradle2nix v2](https://github.com/tadfisher/gradle2nix/tree/v2).
