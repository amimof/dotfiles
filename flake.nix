{
	description = "My Dotfiles";

	outputs = { self, ... }: {
		nixModules.default = import ./nix/linker.nix self;
	};
}
