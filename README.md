# Blackboard Plugin for Neovim
**Status:** In Development

This plugin is currently in the development stage. The file structure, features, and functionality are not yet fully implemented or optimized. Please be aware that the plugin may undergo significant changes as development progresses.

## Features
- Create and manage a blackboard window within Neovim.
- Adjust the size of the blackboard window using the `:BlackboardSize` command.
- Change the color scheme of the blackboard window using the `:BlackboardColor` command.

## Installation
To install the plugin, place the `init.lua` file in your Neovim configuration directory (`~/.config/nvim/`).

## Usage
### Open the Blackboard
Use the leader key `m` to open or close the blackboard window:
```vim
<leader>m
```
Adjust the Blackboard Size
Set the height and width of the blackboard window:

vim
:BlackboardSize <height> <width>
Change the Blackboard Color Scheme
Set the foreground and background colors of the blackboard window:

vim
:BlackboardColor <foreground> <background>
Clear the Blackboard
Use the leader key c to clear the contents of the blackboard window:

vim
<leader>c
Contributing
We welcome contributions to improve this plugin. If you encounter any bugs, have feature requests, or would like to contribute, please feel free to submit a pull request.

How to Contribute
Fork the repository.
Create a new branch (git checkout -b feature-branch).
Make your changes.
Commit your changes (git commit -am 'Add new feature').
Push to the branch (git push origin feature-branch).
Open a pull request.
Thank you for your interest in improving the Blackboard plugin for Neovim!
