-- ~/.config/nvim/init.lua

-- スペースキーをリーダーキーに設定
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- jjを押してESCキーに
vim.api.nvim_set_keymap('i', 'jj', '<ESC>', { noremap = true, silent = true })

-- 保存コマンドを設定（条件付きでバッファが書き込み可能な場合のみ実行）
vim.api.nvim_set_keymap('n', '<leader>w', ':if &buftype == "" | w | endif<CR>', { noremap = true, silent = true })

-- タブを閉じるコマンドを設定
vim.api.nvim_set_keymap('n', '<leader>q', ':q<CR>', { noremap = true, silent = true })

-- カスタムコマンドの例（設定ファイルを再読み込み）
vim.api.nvim_set_keymap('n', '<leader>cga', ':source $MYVIMRC<CR>', { noremap = true, silent = true })

-- プラグイン設定
local blackboard = require('plugins.blackboard')
-- コマンドを作成
vim.api.nvim_create_user_command('OpenBlackboard', 'lua require("plugins.blackboard").open_blackboard()', {})
vim.api.nvim_create_user_command('BlackboardSize', function(opts)
  blackboard.set_blackboard_size(opts.fargs[1], opts.fargs[2])
end, { nargs = '*' })
vim.api.nvim_create_user_command('BlackboardColor', function(opts)
  blackboard.set_blackboard_colors(opts.fargs[1], opts.fargs[2])
end, { nargs = '*' })

-- リーダーキーmでOpenBlackboardコマンドを呼び出すマッピングを作成
vim.api.nvim_set_keymap('n', '<leader>m', ':lua require("plugins.blackboard").open_blackboard()<CR>',
  { noremap = true, silent = true })

-- ブラックボードウィンドウ移動用のマッピングを作成
vim.api.nvim_set_keymap('n', '<C-h>', ':lua require("plugins.blackboard").move_blackboard_window("left")<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', ':lua require("plugins.blackboard").move_blackboard_window("down")<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', ':lua require("plugins.blackboard").move_blackboard_window("up")<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', ':lua require("plugins.blackboard").move_blackboard_window("right")<CR>',
  { noremap = true, silent = true })

-- リーダーキーcでブラックボードをクリアするマッピングを作成
vim.api.nvim_set_keymap('n', '<leader>c', ':lua require("plugins.blackboard").clear_blackboard()<CR>',
  { noremap = true, silent = true })
-- リーダーキーlでブラックボードをロックするマッピングを作成
vim.api.nvim_set_keymap('n', '<leader>l', ':lua require("plugins.blackboard").toggle_lock()<CR>',
  { noremap = true, silent = true })
