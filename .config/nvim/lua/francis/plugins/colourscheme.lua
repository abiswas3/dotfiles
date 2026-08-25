return {

    -- Default colorscheme.
    {
        'navarasu/onedark.nvim',
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('onedark').setup {
                style = 'darker',
                transparent = false, -- Show/hide background
                colors = {
                    bright_orange = '#d19a66',
                    green = '#98c379',
                    red = '#e06c75', -- One Dark's classic soft red/rose
                    blue = '#61afef', -- One Dark's blue, for functions
                    purple = '#c678dd', -- One Dark's purple, good for keywords/control flow
                    white = '#8A8AFF',
                    cyan = '#56b6c2', -- One Dark's cyan, subtle accents
                    yellow = '#FFDB58', -- soft gold, good for structs/types
                },

                highlights = {
                    ['@property.toml'] = { fg = '@blue' },
                    ['@string.special.toml'] = { fg = '@green', bg = '@yellow' },

                    ['@keyword'] = { fg = '$yellow' },
                    -- typst
                    ['@lsp.type.text.typst'] = { fg = '#FFFFF0' },
                    ['@lsp.type.heading.typst'] = { fg = '$white' },
                    ['@lsp.typemod.text.math.typst'] = { fg = '$green' },
                    ['@lsp.typemod.function.math.typst'] = { fg = '$purple' },
                    ['@lsp.type.function.typst'] = { fg = '$white' },
                    ['@lsp.typemod.delim.math.typst'] = { fg = '$red' },
                    ['@lsp.type.ref.typst'] = { fg = '$red' },
                    ['@lsp.typemod.pol.math.typst'] = { fg = '$yellow' },
                    ['@punctuation.bracket.typst'] = { fg = '$bright_orange' },

                    -- markdown
                    ['@@keyword.directive.markdown'] = { fg = '@blue' },
                    ['@spell.markdown '] = { fg = '#FFFFF0' },
                    ['@spell.latex '] = { fg = '#FFFFF0' },
                    ['@markup.heading.2.markdown'] = { fg = '$yellow' },
                    ['@markup.heading.3.markdown'] = { fg = '$red' },
                    [' @markup.math.latex'] = { fg = '$white' },
                    [' @function.latex'] = { fg = '$yellow' },
                    -- rust
                    ['@lsp'] = { fg = 'none' },
                    ['@lsp.typemod.keyword.controlFlow.rust'] = { fg = '$purple', fmt = 'italic' },
                    ['@lsp.type.property'] = { fg = '$bright_orange' },
                    ['@lsp.type.function'] = { fg = '$blue', fmt = 'italic' },
                    ['@lsp.type.method'] = { fg = '$green', fmt = 'bold' }, -- function declarations green
                    ['@lsp.type.struct'] = { fg = '$blue' }, -- structs are blue
                    ['@lsp.type.enum'] = { fg = '$white' }, -- enums are different shade of blue
                    ['@lsp.type.enumMember.rust'] = { fg = '$cyan', fmt = 'bold' },
                    ['@lsp.typemod.method.trait.rust'] = { fg = '$green', fmt = 'italic' },
                },
            }
            require('onedark').load()
        end,
    },
}
