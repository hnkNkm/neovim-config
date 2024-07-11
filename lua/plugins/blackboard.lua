local M = {}
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
local is_locked = false

function M.open_blackboard()
  if blackboard_buf == nil or not api.nvim_buf_is_valid(blackboard_buf) then
    blackboard_buf = api.nvim_create_buf(false, true)
  end

  if blackboard_win and api.nvim_win_is_valid(blackboard_win) then
    api.nvim_win_close(blackboard_win, true)
    blackboard_win = nil
  else
    vim.cmd('highlight BlackboardWindow guifg=' .. blackboard_colors.fg .. ' guibg=' .. blackboard_colors.bg)
    blackboard_win = api.nvim_open_win(blackboard_buf, true, blackboard_win_opts)
    api.nvim_win_set_option(blackboard_win, 'winhl', 'Normal:BlackboardWindow,NormalNC:BlackboardWindow')
  end
end

function M.move_blackboard_window(direction)
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

function M.clear_blackboard()
  if blackboard_buf and api.nvim_buf_is_valid(blackboard_buf) then
    api.nvim_buf_set_lines(blackboard_buf, 0, -1, false, { "" })
  end
end

function M.set_blackboard_size(height, width)
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

function M.set_blackboard_colors(fg, bg)
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

function M.toggle_lock()
  local buf = api.nvim_get_current_buf()
  is_locked = not is_locked
  if is_locked then
    api.nvim_buf_set_option(buf, 'modifiable', false)
    print("Buffer is locked")
  else
    api.nvim_buf_set_option(buf, 'modifiable', true)
    print("Buffer is unlocked")
  end
end

return M
