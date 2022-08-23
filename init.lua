vim.cmd [[packadd packer.nvim]]

vim.g.mapleader = ','
vim.g.localleader = ','

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent= true
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

-- mappings
vim.keymap.set('n', '<Tab>', 'gt')
vim.keymap.set('n', '<S-Tab>', 'gT')
vim.keymap.set('n', '<S-t>', '<cmd>tabnew<CR>')
vim.keymap.set('t', '<Esc>', "<C-\\><C-n>")
vim.keymap.set('n', '<leader>v', "<cmd>vsplit<CR>")
vim.keymap.set('n', '<leader>h', "<cmd>split<CR>")
vim.keymap.set("n", "<Leader>s", ":%s/<C-r><C-w>/") -- replace cword

-- Auto closing is annoying just use this
vim.keymap.set('i', '(<CR>', '(<CR>)<C-c>O')
vim.keymap.set('i', '[<CR>', '[<CR>]<C-c>O')
vim.keymap.set('i', '{<CR>', '{<CR>}<C-c>O')

-- wrapping lines
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

--copypaste
vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>p', '"+p')



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


-- Packer conig
--
require('packer').startup(function(use)
    use { 'https://github.com/rebelot/kanagawa.nvim',
        disable = false,
        config = function()
            require('kanagawa').setup({
                undercurl = true,           -- enable undercurls
                commentStyle = { italic = false },
                functionStyle = { italic = false },
                keywordStyle = { italic = false},
                statementStyle = { bold = true },
                typeStyle = {},
                variablebuiltinStyle = { italic = false},
                specialReturn = true,       -- special highlight for the return keyword
                specialException = true,    -- special highlight for exception handling keywords
                transparent = false,        -- do not set background color
                dimInactive = false,        -- dim inactive window `:h hl-NormalNC`
                globalStatus = false,       -- adjust window separators highlight for laststatus=3
                colors = {},
                overrides = {},
            })
        end,
        run = vim.cmd[[colorscheme kanagawa]]
    }
    use {'https://github.com/NLKNguyen/papercolor-theme', disable = true}
    use { 'https://github.com/projekt0n/github-nvim-theme',
        disable = true,
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
    use 'kyazdani42/nvim-web-devicons'
    use 'ziglang/zig.vim'
    use { 'kevinhwang91/nvim-bqf', ft = 'qf' }
    use {'neovim/nvim-lspconfig', require= {'ms-jpq/coq_nvim' },
        after = 'coq_nvim',
        config = function()
            local nvim_lsp = require('lspconfig')
            local coq = require('coq')
            -- Use an on_attach function to only map the following keys
            -- after the language server attaches to the current buffer
            local on_attach = function(client, bufnr)
                -- local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
                local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

                -- Enable completion triggered by <c-x><c-o>
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
            -- attach servers via loop
            local servers = { 'gopls', 'rust_analyzer', 'zls', 'clangd', 'hls', 'tsserver', 'pyright' }
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
                })
            )
        end
    }
    use { 'ms-jpq/coq_nvim',
        run = ':COQdeps'
    }
    use { 'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup({})
        end
    }
    use { 'nvim-lualine/lualine.nvim', requires = {"kyazdani42/nvim-web-devicons"},
        config = function()
            require('lualine').setup({
                options = {
                    theme='kanagawa',
                    --theme = 'onelight',
                    section_separators = '',
                    component_separators = '',
                    globalstatus=true
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
                ensure_installed = {"go", "typescript", "zig", "json", "lua", "bash", "c", "cpp", "java", "haskell", "rust"},
                --ensure_installed = "all",
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
            vim.keymap.set('n', '<F4>', "<cmd>CHADopen<CR>", { noremap = true, silent = true })
        end
    }
    use 'Olical/aniseed'
    use { 'Olical/conjure',
        config = function()
            vim.keymap.set('n', '<leader>eb', '<cmd>ConjureEvalBuf<CR>', { noremap = true, silent = true })
            vim.keymap.set('n', '<leader>ee', '<cmd>ConjureEvalCurrentForm<CR>', { noremap = true, silent = true })
            vim.keymap.set('n', '<leader>er', '<cmd>ConjureEvalRootForm<CR>', { noremap = true, silent = true })
            vim.keymap.set('n', '<leader>ec', '<cmd>ConjureEvalReplaceForm<CR>', { noremap = true, silent = true })

        end
    }
    use { 'mfussenegger/nvim-dap',
        config = function()
            local dap = require('dap')
            vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end)
            vim.keymap.set("n", "<F5>", function() dap.continue() end)
            vim.keymap.set("n", "<F10>", function() dap.step_over() end)
            vim.keymap.set("n", "<F11>", function() dap.step_into() end)
            dap.adapters.cppdbg = {
                id = 'cppdbg',
                type = 'executable',
                command = '/home/ch/sources/vscode-cpptools/extension/debugAdapters/bin/OpenDebugAD7',
            }
            dap.configurations.cpp = {
                {
                    name = "Launch file",
                    type = "cppdbg",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = true,
                },
                {
                    name = 'Attach to gdbserver :1234',
                    type = 'cppdbg',
                    request = 'launch',
                    MIMode = 'gdb',
                    miDebuggerServerAddress = 'localhost:1234',
                    miDebuggerPath = '/usr/bin/gdb',
                    cwd = '${workspaceFolder}',
                    program = function()
                      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                },
            }
            dap.configurations.c = dap.configurations.cpp
        end
    }
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"}, after='nvim-dap' }
    use { "theHamsta/nvim-dap-virtual-text", requires = {"mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter"},
        config = function()
            require('nvim-dap-virtual-text').setup()
        end
    }
    use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
end)
