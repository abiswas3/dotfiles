-- this makes re-naming/adding prettier: opens a nice box near the cursor.
-- Go to the file explorer and create new file or re-name
return {
  {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
},
{
  'itchyny/calendar.vim',
  config = function()
    -- Optional: Set default view to 'month'
    vim.g.calendar_view = 'month'
  end
}

}
