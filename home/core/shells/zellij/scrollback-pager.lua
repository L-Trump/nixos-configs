-- Zellij "edit scrollback" pager for neovim.
--
-- `EditScrollback ansi=true` makes zellij dump the focused pane's scrollback
-- (ANSI escape codes included) into a temp file and start the command configured
-- in `scrollback_editor` on it.  That command is the `zellij-scrollback-nvim`
-- wrapper (see ./default.nix), and this file is the brain behind the wrapper: it
-- replays the dump into an nvim *terminal* buffer, so colors and text attributes
-- come out exactly like they did inside the pane, with no editor chrome (no line
-- numbers, no status line), and quits with q / Esc / i.
--
-- Same trick as the kitty scrollback pager (home/gui/terminal/kitty-pager.lua),
-- which is what ctrl+shift+space runs inside kitty.
--
-- Environment (set by the wrapper):
--   ZELLIJ_SCROLLBACK_DUMP  dump file produced by zellij (required)
--   ZELLIJ_SCROLLBACK_LINE  row zellij is looking at, 1-indexed (0 = jump to the end)

return function()
  local path = vim.env.ZELLIJ_SCROLLBACK_DUMP
  local line = tonumber(vim.env.ZELLIJ_SCROLLBACK_LINE) or 0

  if not path or path == '' then
    vim.notify('zellij scrollback pager: ZELLIJ_SCROLLBACK_DUMP is not set', vim.log.levels.ERROR)
    return
  end

  vim.opt.encoding = 'utf-8'
  vim.opt.clipboard = 'unnamedplus'
  vim.opt.compatible = false
  vim.opt.number = false
  vim.opt.relativenumber = false
  vim.opt.termguicolors = true
  vim.opt.showmode = false
  vim.opt.ruler = false
  vim.opt.laststatus = 0
  vim.opt.cmdheight = 0
  vim.opt.showcmd = false
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })

  -- keep every row of the dump around in the emulated terminal
  local dump_lines = vim.fn.readfile(path, 'b')
  vim.opt.scrollback = #dump_lines + 100

  local term_buf = vim.api.nvim_create_buf(true, false)
  local term_io = vim.api.nvim_open_term(term_buf, {})
  for _, key in ipairs({ 'q', '<Esc>', 'i' }) do
    vim.api.nvim_buf_set_keymap(term_buf, 'n', key, '<Cmd>q<CR>', { silent = true })
  end

  -- Replay the dump.  Zellij writes one terminal row per line; the emulator
  -- needs the CR (a bare LF would keep the column and mangle the layout).
  for i, dump_line in ipairs(dump_lines) do
    vim.api.nvim_chan_send(term_io, (i > 1 and '\r\n' or '') .. dump_line)
  end
  vim.api.nvim_win_set_buf(0, term_buf)

  local set_cursor = function()
    local total = vim.api.nvim_buf_line_count(term_buf)
    local target = (line > 0 and line <= total) and line or total
    vim.api.nvim_feedkeys(tostring(target) .. 'Gzb', 'n', true)
  end

  local group = vim.api.nvim_create_augroup('zellij-scrollback-pager', {})
  vim.api.nvim_create_autocmd('ModeChanged', {
    group = group,
    buffer = term_buf,
    callback = function()
      if vim.fn.mode() == 't' then
        vim.cmd.stopinsert()
        vim.schedule(set_cursor)
      end
    end,
  })

  -- the channel is drained by the event loop, so wait for it before jumping
  vim.schedule(set_cursor)
end
