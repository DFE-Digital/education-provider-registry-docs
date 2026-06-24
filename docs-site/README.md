# docs-site

This folder contains the [Nanoc](https://nanoc.ws/) site used to publish generated documentation views over the source-controlled feature files in this repository.

Nanoc is a Ruby static site generator. In this repo the docs site is intentionally contained in `docs-site/`: local build scripts live in `docs-site/scripts/`, generated markdown lives in `docs-site/content/`, Ruby dependencies are installed under `docs-site/vendor/bundle/`, and the generated HTML is written to `docs-site/output/`.

The feature pages are generated from the Gherkin `.feature` files in `../features/`.

## Compile the docs locally

Run this command from `docs-site/`:

```powershell
.\scripts\compile-local.ps1
```

The script:

1. Generates Markdown pages from `../features/*.feature`.
2. Configures Bundler to install dependencies under `docs-site/vendor/bundle/`.
3. Installs the Ruby gems if needed.
4. Compiles the Nanoc site into `docs-site/output/`.

After the first successful install, you can skip the Bundler install step when you only want to regenerate and compile the site:

```powershell
.\scripts\compile-local.ps1 -SkipBundleInstall
```

To check the result locally, open `docs-site/output/index.html` in a browser.

If a layout, filter, or generated page change does not appear in the output, delete `docs-site/output/` and `docs-site/tmp/`, then run `.\scripts\compile-local.ps1` again.

## Feature files remain the source of truth

Do not edit generated Markdown under `docs-site/content/features/`.

Edit the `.feature` files under `../features/`, then regenerate and compile the docs site.

## Gherkin rendering

Generated feature pages include:

- A summary table.
- Scenario names and scenario tags.
- The raw feature source in a highlighted Gherkin code block.

The site uses highlight.js for client-side syntax highlighting because it supports the `gherkin` language. The viewer is intentionally simple: it makes the source-controlled `.feature` files easier to read without creating a second behavioural source of truth.

## Publish with GitHub Pages

The intended published site URL is:

`https://dfe-digital.github.io/education-provider-registry-docs/`

GitHub Pages should be configured to publish from GitHub Actions:

1. In the repository on GitHub, go to `Settings` -> `Pages`.
2. Under `Build and deployment`, set `Source` to `GitHub Actions`.
3. In `Settings` -> `Environments` -> `github-pages`, make sure the deployment branch rules allow the branch you want to publish from.
4. Push to the repository default branch, or run the workflow manually from the `Actions` tab.
