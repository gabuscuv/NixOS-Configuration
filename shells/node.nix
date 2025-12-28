{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  name = "nextjs-vscode-dev-shell";

  buildInputs = with pkgs; [
    # Runtime
    nodejs_20
    yarn

    # VS Code / TypeScript support
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.eslint
    nodePackages.prettier
  ];

  shellHook = ''
    echo "⚛️  Next.js dev shell (VS Code)"
    echo "Node: $(node --version)"
    echo "Yarn: $(yarn --version)"

    # Ensure local node_modules/.bin is preferred
    export PATH="$PWD/node_modules/.bin:$PATH"
  '';
}
