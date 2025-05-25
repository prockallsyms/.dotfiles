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

