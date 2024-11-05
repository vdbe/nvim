local o, opt     = vim.o, vim.opt

-- General
o.undofile       = true    -- Enable persistent undo (see also `:h undodir`)

o.backup         = false   -- Don't store backup while overwriting the file
o.writebackup    = false   -- Don't store backup while overwriting the file

o.mouse          = 'a'     -- Enable mouse for all available modes

o.foldlevelstart = 99      -- Start unfolded

o.inccommand     = "split" -- Preview off screen effects of commands

-- Appearance
o.breakindent    = true    -- Indent wrapped lines to match line start
o.cursorline     = true    -- Highlight current line
o.linebreak      = true    -- Wrap long lines at 'breakat' (if 'wrap' is set)
o.number         = true    -- Show line numbers
o.relativenumber = true    -- Show relative lines numbers
o.splitbelow     = true    -- Horizontal splits will be below
o.splitright     = true    -- Vertical splits will be to the right

o.ruler          = false   -- Don't show cursor position in command line
o.showmode       = false   -- Don't show mode in command line
o.wrap           = false   -- Display long lines as just one line

o.signcolumn     = 'yes'   -- Always show sign column (otherwise it will shift text)
o.fillchars      = 'eob: ' -- Don't show `~` outside of buffer

-- Editing
o.ignorecase     = true                        -- Ignore case when searching (use `\C` to force not doing that)
o.incsearch      = true                        -- Show search results while typing
o.infercase      = true                        -- Infer letter cases for a richer built-in keyword completion
o.smartcase      = true                        -- Don't ignore case when searching if pattern has upper case
o.smartindent    = true                        -- Make indenting smart

o.completeopt    = 'menuone,noinsert,noselect' -- Customize completions
o.virtualedit    = 'block'                     -- Allow going past the end of line in visual block mode
o.formatoptions  = 'qjl1'                      -- Don't autoformat comments

-- Neovim version dependent
if vim.fn.has('nvim-0.9') == 1 then
  opt.shortmess:append('WcC') -- Reduce command line messages
  o.splitkeep = 'screen'      -- Reduce scroll during window split
else
  opt.shortmess:append('Wc')  -- Reduce command line messages
end

if vim.fn.has('nvim-0.10') == 0 then
  o.termguicolors = true -- Enable gui colors
end

-- NOTE: Having `tab` present is needed because `^I` will be shown if
-- omitted (documented in `:h listchars`).
-- Having it equal to a default value should be less intrusive.
o.listchars = 'tab:> ,extends:…,precedes:…,nbsp:␣' -- Define which helper symbols to show
o.list      = true -- Show some helper symbols
