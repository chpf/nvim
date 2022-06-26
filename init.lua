vim.cmd [[packadd packer.nvim]]

vim.g.mapleader = ','
vim.g.localleader = ','

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = 'a'
vim.opt.inccommand = "nosplit"
vim.opt.splitright = true
vim.opt.fileencoding = "utf-8"
vim.opt.smartcase = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.inccommand = "nosplit"
-- vim.cmd[[set laststatus=3]]
-- vim.opt.listchars:append("eol:¬")
-- vim.opt.listchars:append("tab:▸")
vim.opt.list = true
vim.opt.laststatus = 3
vim.opt.background = "light"

-- mappings
vim.api.nvim_set_keymap('n', '<Tab>', 'gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Tab>', 'gT', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-t>', '<cmd>tabnew<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<Esc>', "<C-\\><C-n>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>v', "<cmd>vsplit<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>h', "<cmd>split<CR>", { noremap = true, silent = true })

-- Auto closing is annoying just use this
vim.api.nvim_set_keymap('i', '(<CR>', '(<CR>)<C-c>O', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '[<CR>', '[<CR>]<C-c>O', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '{<CR>', '{<CR>}<C-c>O', { noremap = true, silent = true })

-- wrapping lines
vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = true, silent = true })

--copypaste
vim.api.nvim_set_keymap('n', '<leader>y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>p', '"+p', { noremap = true, silent = true })



-- fun stuff
-- gets the oldest terminal channel id
local get_first_terminal = function()
    local terminal_chans = {}
    for _, chan in pairs(vim.api.nvim_list_chans()) do
        if chan["mode"] == "terminal" and chan["pty"] ~= "" then
            table.insert(terminal_chans, chan)
        end
    end
    if rawequal(next(terminal_chans), nil) then
        -- no terminal open, return nil
        return nil
    end
    -- return oldest
    table.sort(terminal_chans, function(left, right)
        return left["buffer"] < right["buffer"]
    end)
    return terminal_chans[1]["id"]
end

-- send Text to the oldest terminal
-- :lua terminal_send('lol')
local terminal_send = function(text)
    local first_terminal_chan = get_first_terminal()
    if first_terminal_chan ~= nil then
        vim.api.nvim_chan_send(first_terminal_chan, text)
    end
end

-- auto cmds
local haskell_group = vim.api.nvim_create_augroup("HaskellAuGroup", { clear = true })
local au_group = vim.api.nvim_create_augroup("MiscAuGroup", { clear = true })

-- send :r to terminal buffer on safe (reloads ghci)
vim.api.nvim_create_autocmd({ "BufWrite" }, {
    group = haskell_group,
    pattern = "*.hs",
    callback = function()
        vim.schedule(function()
            terminal_send(':r\n')
        end)
    end
})

-- auto relead vim config
vim.api.nvim_create_autocmd({"BufWritePost"}, {
    group = au_group,
    pattern = "init.lua",
    command = "source <afile> | PackerCompile"
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

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end, { buffer = true })
    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, { buffer = true })
    vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end, { buffer = true })
    vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, { buffer = true })
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, { buffer = true })
    vim.keymap.set('n', '<C-k>', function() vim.lsp.buf.signature_help() end, { buffer = true })
    vim.keymap.set('n', 'gT', function() vim.lsp.buf.type_definition() end, { buffer = true })
    vim.keymap.set('n', '<F2>', function() vim.lsp.buf.rename() end, { buffer = true })
    vim.keymap.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, { buffer = true })
    vim.keymap.set('n', '<leader>e', function() vim.diagnostic.open_float() end, { buffer = true })
    vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next() end, { buffer = true })
    vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev() end, { buffer = true })
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({async=true}) end, { buffer = true })
end


-- lspconfig
local nvim_lsp = require('lspconfig')
local coq = require('coq')

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'gopls', 'rust_analyzer', 'zls', 'clangd', 'hls', 'bashls' }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup(
        coq.lsp_ensure_capabilities({
            on_attach = on_attach,
        })
    )
end

--- LUA lsp CONFIG outside of loop, since it needs specific setup
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
nvim_lsp.sumneko_lua.setup(
    coq.lsp_ensure_capabilities({
        on_attach = on_attach,
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                    path = runtime_path,
                },
                diagnostics = {
                    globals = { 'vim' },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false,
                },
            },
        }
    }
    ))

-- Packer conig
--
require('packer').startup(function(use)
    use { 'https://github.com/rebelot/kanagawa.nvim',
        config = function()
            -- require('kanagawa').setup({
            --     undercurl = true,
            --     commentStyle = "NONE",
            --     functionStyle = "NONE",
            --     keywordStyle = "NONE",
            --     statementStyle = "bold",
            --     typeStyle = "NONE",
            --     variablebuiltinStyle = "NONE",
            --     specialReturn = false,
            --     specialException = false,
            --     transparent = true,
            -- })
            -- vim.cmd("colorscheme kanagawa")
        end
    }
    use { 'https://github.com/projekt0n/github-nvim-theme',
        config = function()
            require('github-theme').setup({
                dark_sidebar = false,
                dark_float = false,
                theme_style = "light",
                sidebars = { "qf", "vista_kind", "terminal", "packer" },
                hide_inactive_statusline = false,
                keyword_style = "bold",
                function_style = "NONE",
                comment_style = "NONE",
                -- transparent=true,
            })
        end
    }
    use { 'https://github.com/junegunn/vim-easy-align',
        config = function()
            vim.keymap.set('n', 'ga', '<Plug>(EasyAlign)')
            vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)')
        end }
    use 'wbthomason/packer.nvim'
    use 'https://github.com/NLKNguyen/papercolor-theme'
    use 'kyazdani42/nvim-web-devicons'
    use 'ziglang/zig.vim'
    use { 'kevinhwang91/nvim-bqf', ft = 'qf' }
    use 'neovim/nvim-lspconfig'
    use { 'ms-jpq/coq_nvim',
        run = ':COQdeps'
    }
    use { 'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup({})
        end
    }
    use { 'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup({
                options = {
                    -- theme='kanagawa',
                    theme = 'onelight',
                    section_separators = '',
                    component_separators = '',
                    -- globalstatus=true
                }
            })
        end
    }
    use { 'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("indent_blankline").setup({
                -- for example, context is off by default, use this to turn it on
                show_current_context = true,
                show_current_context_start = true,
            })
        end
    }
    use { 'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = "all",
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                rainbow = {
                    enable = true,
                    colors = {
                        "Gold",
                        "Orchid",
                        "DodgerBlue",
                    },
                },
            })
        end
    }
    use { 'https://github.com/ibhagwan/fzf-lua',
        config = function()
            local fzf = require('fzf-lua')
            fzf.setup({
                fzf_colors = {
                    ["bg"]  = { "bg", "Normal" },
                    ["fg+"] = { "fg", "Exception" },
                    ["bg+"] = { "bg", "Normal" },
                },
            })
            vim.keymap.set('n', '<Space>', function() fzf.files() end, { noremap = true, silent = true })
            vim.keymap.set('n', '<leader><Space>', function() fzf.files({ cwd = '~/.config' }) end, { noremap = true, silent = true })
            vim.keymap.set('n', 'b<Space>', function() fzf.buffers() end, { noremap = true, silent = true })
            vim.keymap.set('n', 'g<Space>', function() fzf.live_grep_native() end, { noremap = true, silent = true })
            vim.keymap.set('n', 's<Space>', function() fzf.lsp_document_symbols() end, { noremap = true, silent = true })
        end
    }

    use { 'ms-jpq/chadtree',
        run = ':CHADdeps',
        config = function()
            vim.api.nvim_set_keymap('n', '<F4>', "<cmd>CHADopen<CR>", { noremap = true, silent = true })
        end
    }
    use 'Olical/aniseed'
    use { 'Olical/conjure',
        config = function()
            vim.api.nvim_set_keymap('n', '<leader>eb', '<cmd>ConjureEvalBuf<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>ee', '<cmd>ConjureEvalCurrentForm<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>er', '<cmd>ConjureEvalRootForm<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>ec', '<cmd>ConjureEvalReplaceForm<CR>', { noremap = true, silent = true })

        end
    }
    use { 'mfussenegger/nvim-dap',
        config = function()
            local dap = require('dap')
            vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end)
            vim.keymap.set("n", "<F5>", function() dap.continue() end)
            vim.keymap.set("n", "<F10>", function() dap.step_over() end)
            vim.keymap.set("n", "<F11>", function() dap.step_into() end)
        end
    }
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
    use { "theHamsta/nvim-dap-virtual-text", requires = {"mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter"},
        config = function()
            require("nvim-dap-virtual-text").setup()
        end
    }
end)
