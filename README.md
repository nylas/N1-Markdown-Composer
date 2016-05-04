
# N1 Markdown Composer

A plugin for N1 that allows you to compose emails using markdown.

![Markdown Screenshot](/assets/markdown_screenshot.png?raw=true "Markdown Composer")

## Install this plugin:

1. Download and run N1

2. Clone this repository (Make sure you have `git` installed and available in
   your system path)

2. From the menu, select `Developer > Install a Package Manually...`
   From the dialog, choose the directory of this plugin to install it!

   > When you install packages, they're moved to `~/.nylas/packages`,
   > and N1 runs `apm install` on the command line to fetch dependencies
   > listed in the package's `package.json`

3. Installation of the package will fail due to [this issue](https://github.com/atom/apm/issues/355).
   To complete the installation, go to the directory `~/.nylas/packages/N1-Markdown-Composer`
   and run

   `apm install`

   See
   [here](https://github.com/nylas/N1-Markdown-Composer/issues/9#issuecomment-201135713) for more details

## Usage

Just write emails using markdown.
