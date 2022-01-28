[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![CELPA](https://celpa.conao3.com/packages/eldoc-meta-net-badge.svg)](https://celpa.conao3.com/#/eldoc-meta-net)
[![JCS-ELPA](https://raw.githubusercontent.com/jcs-emacs/jcs-elpa/master/badges/v/eldoc-meta-net.svg)](https://jcs-emacs.github.io/jcs-elpa/#/eldoc-meta-net)

# eldoc-meta-net
> Eldoc support for meta-net

![CI](https://github.com/emacs-vs/eldoc-meta-net/workflows/CI/badge.svg)

<p align="center">
  <img src="./etc/demo.png" width="543" height="279" />
</p>

## :floppy_disk: Quickstart

```el
(use-package company-meta-net
  :ensure t
  :hook (csharp-mode . (lambda () (eldoc-meta-net-enable))))
```

## :hammer: Configurations

#### `eldoc-meta-net-display-summary`

Display parameter's summary under ElDoc.

## Contribute

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)
[![Elisp styleguide](https://img.shields.io/badge/elisp-style%20guide-purple)](https://github.com/bbatsov/emacs-lisp-style-guide)

If you would like to contribute to this project, you may either
clone and make pull requests to this repository. Or you can
clone the project and establish your own branch of this tool.
Any methods are welcome!
