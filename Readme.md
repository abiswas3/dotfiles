To remove symlinks that i created. 
```zsh
stow -D . 
```
To specify a target directory, which in this case is the parent/home directory and . is the current directory which is being sym-linked
```zsh
stow -t ~ . 
```
More simply 
```zsh
stow . 
``` 
uses the default target as the parent directory.

