## My dotfiles

Enjoy ig, you'll need to install a bunch of stuff. Script for that incoming...

### First time setup

To get started, make sure you have GNU stow installed. Run the following commands:

```bash
cd && git clone https://github.com/prockallsyms/.dotfiles.git
cd .dotfiles
stow -v .
```

Make sure you set your custom fish environment variables (cargo/go bin storage directory!) in `$HOME/.local/share/env.fish`!

For Neovim, make sure that you're using the latest version (`nvm use latest` lol) and that you follow the instructions to install `copilot.nvim` if you plan on using it.

As an added bonus, if you are not me and want to learn the keybindings I've set, you can grep for them with `grep -R 'vim.keymap.set'` or by entering Neovim and pressing `<Space>?`.
