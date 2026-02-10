-- nvim-surround: Add/change/delete surrounding pairs (quotes, brackets, tags, etc.)
-- ys{motion}{char} to add, cs{old}{new} to change, ds{char} to delete.
-- e.g. ysiw" wraps word in quotes, cs"' changes " to ', ds" removes quotes.
return { 'kylechui/nvim-surround', config = true }
