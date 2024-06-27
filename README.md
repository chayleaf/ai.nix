I've been creating one-off derivations for certain Python modules that I
don't wanna maintain (i.e. upstream to nixpkgs), so now I've decided to
put them here whenever I work on them. No guarantees are made of stuff
continuing to work in the future obviously.

Most importantly, ComfyUI is packaged (in an opinionated way)
`custom_nodes` for ComfyUI are packaged, models aren't (I just don't
want to have 30GB of models in my Nix store).
