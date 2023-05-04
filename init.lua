vim.g.mapleader=','
vim.g.localleader=','

vim.o.conceallevel = 2

vim.o.backup = false
vim.o.swapfile = false
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.ignorecase = true
vim.o.laststatus = 3
vim.o.list = false
vim.o.clipboard="unnamedplus"
vim.o.breakindent = true
vim.o.termguicolors = true
vim.o.completeopt = 'menu,menuone'
vim.wo.signcolumn = 'yes'
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.scrolloff = 3

vim.wo.number = false
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.mouse = 'a'

if vim.loop.os_uname().sysname ~= 'Linux' then
--if vim.fn.has('win32') then (This shit doesnt work)
  vim.opt.shell = vim.fn.executable "pwsh" and "pwsh" or "powershell"
  vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
  vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
  vim.keymap.set("n", "<Leader>init", "<cmd>e C:/Users/hansa/AppData/Local/nvim/init.lua<CR>")
else
  vim.opt.shell = vim.fn.executable 'nu' and '/home/christian/.cargo/bin/nu'
end

vim.keymap.set('n', '<Tab>', 'gt')
vim.keymap.set('n', '<S-Tab>', 'gT')
vim.keymap.set('n', '<S-t>', '<cmd>tabnew<CR>')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('n', '<leader>v', '<cmd>vsplit<CR>')
vim.keymap.set('n', '<leader>h', '<cmd>split<CR>')
vim.keymap.set("n", "<Leader>s", ":%s/<C-r><C-w>/")

-- keep cursor steady
vim.keymap.set('n', 'J' , 'mzJ`z')
vim.keymap.set('n', '<C-d>' , '<C-d>zz')
vim.keymap.set('n', '<C-u>' , '<C-u>zz')
vim.keymap.set('n', 'n' , 'nzzzv')
vim.keymap.set('n', 'N' , 'Nzzzv')


-- vim.keymap.set('i', '<S-Tab>', '<C-d>')
-- vim.keymap.set('i', '<Tab>', '<C-t>')



-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('v', '<' , '<gv')
vim.keymap.set('v', '>' , '>gv')


vim.keymap.set('i', '(<CR>', '(<CR>)<C-c>O')
vim.keymap.set('i', '{<CR>', '{<CR>}<C-c>O')
vim.keymap.set('i', '[<CR>', '[<CR>]<C-c>O')

vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>p', '"+p')

vim.opt.signcolumn = "no"

local au_group = vim.api.nvim_create_augroup("MiscAuGroup", {clear = true})
vim.api.nvim_create_autocmd({"BufWritePost"}, {
	group = au_group,
	pattern = "init.lua",
	command = "source <afile>"
})

-- toggle open/close  the quickfix window with
local toggle_qlist = '<leader>q'
vim.api.nvim_set_keymap('n', toggle_qlist, '<cmd>copen<CR>', { noremap = true, silent = true })
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    group = au_group,
    pattern = "quickfix",
    callback = function()
        vim.schedule(function()
            vim.api.nvim_buf_set_keymap(0, 'n', toggle_qlist, '<cmd>cclose<CR>', { noremap = true, silent = true })
        end)
    end
})


-- My super basic Color scheme, no extra file needed
local highlight_fg = '#FAFF00'
local background_fg = '#2D2A2E'
local text_fg = '#FCFCFA'
local comment_fg = '#CCCCAC'

if vim.g.neovide then
  vim.g.remember_window_size = true
	vim.opt.guifont = {"ProggyCleanTT NFM" }
	vim.g.neovide_scale_factor = 1.1
	vim.g.neovide_floating_blur_amount_x = 12.0
	vim.g.neovide_floating_blur_amount_y = 12.0
	-- vim.g.transparency = 1.0
	vim.g.neovide_transparency = 0.88

	vim.api.nvim_set_hl(0, "Constant",              { bg=background_fg, fg=highlight_fg })
	vim.api.nvim_set_hl(0, "Normal",                { bg=background_fg, fg=text_fg })
	vim.api.nvim_set_hl(0, "Identifier",            { bg=background_fg, fg=text_fg })
	vim.api.nvim_set_hl(0, "Statement",             { bg=background_fg, fg=text_fg })
	vim.api.nvim_set_hl(0, "Type",                  { bg=background_fg, fg=text_fg })
	vim.api.nvim_set_hl(0, "Special",               { bg=background_fg, fg=text_fg })
	vim.api.nvim_set_hl(0, "EndOfBuffer",           { bg=background_fg, fg=text_fg })
	vim.api.nvim_set_hl(0, "SpecialKey",            { bg=background_fg, fg=text_fg })
	vim.api.nvim_set_hl(0, "NonText",               { bg=background_fg, fg=text_fg })
	vim.api.nvim_set_hl(0, "Ignore",                { bg=background_fg, fg=text_fg })
	vim.api.nvim_set_hl(0, "Comment",               { bg=background_fg, fg=comment_fg })
	vim.api.nvim_set_hl(0, "Pmenu",                 { bg="#1E1E1E"    , fg=text_fg })
	vim.api.nvim_set_hl(0, "PmenuSel",              { bg="#131313"    , fg=highlight_fg })
	vim.api.nvim_set_hl(0, "Cursor",                { bg=text_fg      , fg=background_fg })
	vim.api.nvim_set_hl(0, "Visual",                { bg=text_fg      , fg=background_fg })
	vim.api.nvim_set_hl(0, "Error",                 { bg=background_fg, fg="#FF1029" })
	vim.api.nvim_set_hl(0, "Todo",                  { bg=background_fg, fg="#FFAA00" })
	vim.api.nvim_set_hl(0, "fzf1",                  { bg=background_fg, fg=text_fg })
	vim.api.nvim_set_hl(0, "fzf2",                  { bg=text_fg      , fg="#FFAA00" })
	vim.api.nvim_set_hl(0, "fzf3",                  { bg=background_fg, fg=text_fg })
	vim.api.nvim_set_hl(0, "Folded",                { bg=background_fg, fg=text_fg })
	vim.api.nvim_set_hl(0, "FoldColumn",            { bg=background_fg, fg=text_fg })
	vim.api.nvim_set_hl(0, "IndentBlanklineIndent", { bg=background_fg, fg='#5F5F5F' })
else
    vim.cmd('colorscheme slate')
    vim.api.nvim_set_hl(0, "Comment",  { bg=nil, fg=comment_fg })
    -- vim.cmd('colorscheme habamax')
	  vim.api.nvim_set_hl(0, "Normal",  { bg= nil })
	  vim.api.nvim_set_hl(0, "MatchParen",  { bg= nil })
	  vim.api.nvim_set_hl(0, "IndentBlanklineIndent", { bg=nil, fg='#5F5F5F' })
	  vim.api.nvim_set_hl(0, "NonText",  { bg= nil })

end


return require('packer').startup(function(use)
	use { 'wbthomason/packer.nvim' }
	use { 'wellle/targets.vim' }
  use { 'chaoren/vim-wordmotion' }
	use { 'nvim-lua/plenary.nvim'}
	use { 'numToStr/Comment.nvim', config = function() require('Comment').setup({}) end }
  use { "tpope/vim-fugitive" }
	use { 'nvim-lualine/lualine.nvim',
		config = function()
			require('lualine').setup({
				options = {
					icons_enabled = false,
					component_separators = '|',
					section_separators = '',
					globalstatus = true
				}
			})
		end
	}
	use { 'lukas-reineke/indent-blankline.nvim',
		config = function()
			require('indent_blankline').setup({
				char = '┊',
      	show_trailing_blankline_indent = false,
        char_highlight_list = {"IndentBlanklineIndent"},
			})
		end
	}
  use { 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'zig', 'vim' },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        }
      }
    end
  }
  use { 'nvim-treesitter/nvim-treesitter-context' }
	use { 'nvim-telescope/telescope.nvim', requires = {'nvim-lua/plenary.nvim'},
		config = function()
			local telescope = require('telescope')
			telescope.setup({
        extensions = {
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          }
        },
      })
			vim.keymap.set('n', '<Space>', require('telescope.builtin').find_files, { desc = 'Search Files' })
      -- vim.keymap.set('n', '<Space>.', require('telescope.builtin').find_files({search_dirs = {"~/.config"}}), { desc = 'Search by Grep' })
			vim.keymap.set('n', '<Space>g', require('telescope.builtin').live_grep, { desc = 'Search by Grep' })
			vim.keymap.set('n', '<Space>b', require('telescope.builtin').buffers, { desc = 'Find existing buffers' })
			vim.keymap.set('n', '<Space>s', require('telescope.builtin').git_files, { desc = 'Search git files' })
      vim.keymap.set('n', '<Space>t', require('telescope.builtin').tags, { desc = 'Search tags' })
      vim.keymap.set('n', '<Space>r', require('telescope.builtin').registers, { desc = 'Search registers' })
      vim.keymap.set('n', '<Space>h', require('telescope.builtin').help_tags, { desc = 'Search help tags' })
      vim.keymap.set('n', '<Space>c', require('telescope.builtin').commands, { desc = 'Search commands' })
      vim.keymap.set('n', '<Space>m', require('telescope.builtin').marks, { desc = 'Search marks' })
      vim.keymap.set('n', '<Space>k', require('telescope.builtin').keymaps, { desc = 'Search keymaps' })
      vim.keymap.set('n', '<Space>l', require('telescope.builtin').loclist, { desc = 'Search loclist' })
      vim.keymap.set('n', '<Space>z', require('telescope.builtin').spell_suggest, { desc = 'Search spell suggest' })
      vim.keymap.set('n', '<Space>o', require('telescope.builtin').vim_options, { desc = 'Search vim options' })
      vim.keymap.set('n', '<Space>q', require('telescope.builtin').quickfix, { desc = 'Search quickfix' })


			vim.keymap.set('n', '//', function()
			  -- You can pass additional configuration to telescope to change theme, layout, etc.
			  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
			    winblend = 10,
			    previewer = false,
			  })
			end, { desc = '[/] Fuzzily search in current buffer' })

		end
	}
	use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' , requires = {'nvim-telescope/telescope.nvim'},
    config = function()
			  require('telescope').load_extension('fzf')
      end
    }
  use {
    'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('gitsigns').setup() end
  }
  use {'hrsh7th/cmp-nvim-lsp'}
  use {'hrsh7th/nvim-cmp', requires = {'hrsh7th/cmp-nvim-lsp'},
    config = function()
      local cmp = require('cmp')
      cmp.setup{
        mapping = cmp.mapping.preset.insert {
          ['<C-f>'] = cmp.mapping.complete {},
          ['<C-n>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-p>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'copilot'}
        },
      }
    end
  }
  use { "chrisgrieser/nvim-various-textobjs",
    config  = function()
		  require("various-textobjs").setup({ useDefaultKeymaps = false }) -- use keymaps provided by plugin
    end
  }
  use { 'junegunn/vim-easy-align' ,
    config = function()
      -- vim.keymap.set('x', 'ga', function() vim.cmd("EasyAlign<CR>") end )
      -- vim.keymap.set('n', 'ga', function() vim.cmd("EasyAlign<CR>") end )
    end
  }
  use { "folke/neodev.nvim" }
  use { 'williamboman/mason.nvim' }
  use { 'williamboman/mason-lspconfig.nvim', after = 'mason.nvim'}
  use { 'neovim/nvim-lspconfig', after = {'mason-lspconfig.nvim', 'cmp-nvim-lsp', 'neodev.nvim'},
    config = function()
      local on_attach = function(_, buffnr)
        local function buf_set_option(...) vim.api.nvim_buf_set_option(buffnr, ...) end
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
        vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end)
        vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end)
        vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end)
        vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end)
        vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end)
        vim.keymap.set('n', '<C-k>', function() vim.lsp.buf.signature_help() end)
        vim.keymap.set('n', 'gT', function() vim.lsp.buf.type_definition() end)
        vim.keymap.set('n', '<F2>', function() vim.lsp.buf.rename() end)
        vim.keymap.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end)
        vim.keymap.set('n', '<leader>e', function() vim.diagnostic.open_float(nil, {focus=false}) end)
        vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next() end)
        vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev() end)
        vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({async=true}) end)
      end
      local servers = {
        rust_analyzer = {},
        zls ={},
        clangd = {},
        lua_ls = {
          Lua = {
            workspace = {
              checkThirdParty = false
            }
          }
        }
      }

      require("neodev").setup({ })
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      require('mason').setup()
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers)
      })
      require("mason-lspconfig").setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup{
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name]
          }
        end
      }
    end
  }
  use { "mbbill/undotree",
    config = function()
      vim.keymap.set('n', '<leader>u', function() vim.cmd("UndotreeToggle") end )
    end
  }
  use("github/copilot.vim")
  use('gpanders/nvim-parinfer')
  use{'Olical/conjure' ,
    config = function()
      vim.keymap.set('n', '<leader>ce', function() vim.cmd("ConjureEval") end )
      vim.keymap.set('n', '<leader>cb', function() vim.cmd("ConjureEvalBuf") end )
      vim.keymap.set('n', '<leader>cd', function() vim.cmd("ConjureDef") end )
    end
  }
end)

-- vim: ts=2 sts=2 sw=2 et
