[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![CI](https://github.com/emacs-vs/eldoc-meta-net/workflows/CI/badge.svg)

# eldoc-meta-net
> Eldoc support for meta-net

<img src="./etc/demo.png" width="543" height="279" />

## :floppy_disk: Quickstart

```el
(use-package company-meta-net
  :ensure t
  :hook (csharp-mode . (lambda () (eldoc-meta-net-enable))))
```

## :hammer: Configurations

#### `eldoc-meta-net-display-summary`

Display parameter's summary under ElDoc.

## Contribution

If you would like to contribute to this project, you may either
clone and make pull requests to this repository. Or you can
clone the project and establish your own branch of this tool.
Any methods are welcome!
