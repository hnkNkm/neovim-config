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

-- blackboardプラグインの機能を定義
local api = vim.api
local blackboard_buf = nil
local blackboard_win = nil
local blackboard_win_opts = {
  relative = 'editor',
  width = 80,
  height = 20,
  col = 10,
  row = 10,
  style = 'minimal',
  border = 'single'
}
local blackboard_colors = { fg = 'white', bg = '#00008B' }

function _G.open_blackboard()
  if blackboard_buf == nil or not api.nvim_buf_is_valid(blackboard_buf) then
    -- バッファが存在しない場合、新規作成
    blackboard_buf = api.nvim_create_buf(false, true)
    -- ブラックボードのタイトルを設定
    api.nvim_buf_set_lines(blackboard_buf, 0, -1, false, { "Blackboard", "--------" })
  end

  if blackboard_win and api.nvim_win_is_valid(blackboard_win) then
    -- ウィンドウが存在する場合、閉じる
    api.nvim_win_close(blackboard_win, true)
    blackboard_win = nil
  else
    -- ハイライトグループを設定
    vim.cmd('highlight BlackboardWindow guifg=' .. blackboard_colors.fg .. ' guibg=' .. blackboard_colors.bg)

    -- ウィンドウを新規作成し、バッファを設定
    blackboard_win = api.nvim_open_win(blackboard_buf, true, blackboard_win_opts)
    -- ウィンドウのハイライトを設定
    api.nvim_win_set_option(blackboard_win, 'winhl', 'Normal:BlackboardWindow,NormalNC:BlackboardWindow')
  end
end

function _G.move_blackboard_window(direction)
  if blackboard_win and api.nvim_win_is_valid(blackboard_win) then
    if direction == "up" then
      blackboard_win_opts.row = blackboard_win_opts.row - 1
    elseif direction == "down" then
      blackboard_win_opts.row = blackboard_win_opts.row + 1
    elseif direction == "left" then
      blackboard_win_opts.col = blackboard_win_opts.col - 1
    elseif direction == "right" then
      blackboard_win_opts.col = blackboard_win_opts.col + 1
    end
    api.nvim_win_set_config(blackboard_win, blackboard_win_opts)
  end
end

function _G.clear_blackboard()
  if blackboard_buf and api.nvim_buf_is_valid(blackboard_buf) then
    -- 3行目以降をクリア
    api.nvim_buf_set_lines(blackboard_buf, 2, -1, false, { "" })
  end
end

function _G.set_blackboard_size(height, width)
  height = tonumber(height)
  width = tonumber(width)
  if height and width then
    blackboard_win_opts.height = height
    blackboard_win_opts.width = width
  else
    blackboard_win_opts.height = 20
    blackboard_win_opts.width = 80
  end
  if blackboard_win and api.nvim_win_is_valid(blackboard_win) then
    api.nvim_win_set_config(blackboard_win, blackboard_win_opts)
  end
end

function _G.set_blackboard_colors(fg, bg)
  if fg and bg then
    blackboard_colors.fg = fg
    blackboard_colors.bg = bg
  else
    blackboard_colors.fg = 'white'
    blackboard_colors.bg = '#00008B'
  end
  if blackboard_win and api.nvim_win_is_valid(blackboard_win) then
    vim.cmd('highlight BlackboardWindow guifg=' .. blackboard_colors.fg .. ' guibg=' .. blackboard_colors.bg)
    api.nvim_win_set_option(blackboard_win, 'winhl', 'Normal:BlackboardWindow,NormalNC:BlackboardWindow')
  end
end

-- コマンドを作成
api.nvim_create_user_command('OpenBlackboard', 'lua open_blackboard()', {})
api.nvim_create_user_command('BlackboardSize', function(opts)
  _G.set_blackboard_size(opts.fargs[1], opts.fargs[2])
end, { nargs = '*' })
api.nvim_create_user_command('BlackboardColor', function(opts)
  _G.set_blackboard_colors(opts.fargs[1], opts.fargs[2])
end, { nargs = '*' })

-- リーダーキーmでOpenBlackboardコマンドを呼び出すマッピングを作成
vim.api.nvim_set_keymap('n', '<leader>m', ':lua open_blackboard()<CR>', { noremap = true, silent = true })

-- ブラックボードウィンドウ移動用のマッピングを作成
vim.api.nvim_set_keymap('n', '<C-h>', ':lua move_blackboard_window("left")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', ':lua move_blackboard_window("down")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', ':lua move_blackboard_window("up")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', ':lua move_blackboard_window("right")<CR>', { noremap = true, silent = true })

-- リーダーキーcでブラックボードをクリアするマッピングを作成
vim.api.nvim_set_keymap('n', '<leader>c', ':lua clear_blackboard()<CR>', { noremap = true, silent = true })

