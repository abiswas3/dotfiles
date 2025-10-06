return {
    {
        "MunifTanjim/nui.nvim",
        lazy = true,  -- optional
    },
    {
        "daurnimator/luatz",  -- timezone library we also use,
        lazy=false, --force start
    },
    {
  "vhyrro/luarocks.nvim",
  priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
  config = true,
	}
}
