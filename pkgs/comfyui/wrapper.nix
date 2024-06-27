{ unwrapped
, lib
, symlinkJoin
, python3
}:

let
  wrapper = { pythonPackages ? (_: [ ]), customNodes ? (_: [ ]) }:
    let
      customNodes' = customNodes unwrapped.customNodes;
      extraPythonPackages = builtins.concatLists (map (p: p.propagatedBuildInputs or [ ]) customNodes');
    in
    symlinkJoin {
      name = "${unwrapped.pname}-wrapped-${unwrapped.version}";

      inherit unwrapped;
      paths = [ unwrapped ] ++ customNodes';
      pythonPath = pythonPackages python3.pkgs ++ unwrapped.propagatedBuildInputs ++ extraPythonPackages;

      nativeBuildInputs = [ python3.pkgs.wrapPython ];

      postBuild = ''
        rm -f $out/nix-support/propagated-build-inputs
        rmdir $out/nix-support || true
        rm -rf $out/bin
        mkdir -p $out/bin
        echo "#!/usr/bin/env python3" > "$out/bin/comfyui"
        cat "$out/${python3.sitePackages}/main.py" >> "$out/bin/comfyui"
        # convert symlink into file
        sed -i 's/a/a/' "$out/${python3.sitePackages}/folder_paths.py"
        chmod +x "$out/bin/comfyui"
        wrapPythonProgramsIn "$out/bin" "$out $pythonPath"
      '';

      passthru = {
        inherit  unwrapped;python = python3;
        withPythonPackages = filter: wrapper {
          pythonPackages = pkgs: pythonPackages pkgs ++ filter pkgs;
          inherit customNodes;
        };
        withCustomNodes = filter: wrapper {
          customNodes = pkgs: customNodes pkgs ++ filter pkgs;
          inherit pythonPackages;
        };
      };

      meta.priority = (unwrapped.meta.priority or 0) - 1;
    };
in
wrapper
