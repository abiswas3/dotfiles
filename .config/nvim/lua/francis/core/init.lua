require 'francis.core.options'
require 'francis.core.keymaps'

-- Disable native rust_analyzer early — rustaceanvim manages it.
-- Must run before any Rust buffer is opened to prevent a duplicate LSP client.
vim.lsp.enable('rust_analyzer', false)

-- Wrap text in every diff window, including both sides of nvimdiff.
local function enable_diff_wrap()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.wo[win].diff then
            vim.api.nvim_set_option_value("wrap", true, { win = win })
            vim.api.nvim_set_option_value("linebreak", true, { win = win })
            vim.api.nvim_set_option_value("breakindent", true, { win = win })
        end
    end
end

vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
    callback = enable_diff_wrap,
})
