-- :ScheduleClock toggles a display-only clock for the current buffer.
-- Opening a file named today.md enables it automatically.
-- Each hour has two editable lines: :00-:29, then :30-:59.
-- today.md gets its slot spacing tidied on opening and before saving.
-- Bare hours use a daytime schedule: 9-11 AM, 12 noon, 1-8 PM.
-- Explicit 24-hour headings (0 and 13-23) also work.
if vim.g.loaded_schedule_clock then
  return
end
vim.g.loaded_schedule_clock = true

local api = vim.api
local ns = api.nvim_create_namespace('schedule_clock')
local group = api.nvim_create_augroup('ScheduleClock', { clear = true })
local enabled = {}
local timer

local function highlights()
  api.nvim_set_hl(0, 'ScheduleClockTime', { default = true, link = 'IncSearch' })
  api.nvim_set_hl(0, 'ScheduleClockSlot', { default = true, link = 'CursorLine' })
end

local function headings(buf)
  local result = {}
  local previous
  local lines = api.nvim_buf_get_lines(buf, 0, -1, false)
  for i, line in ipairs(lines) do
    local hour = tonumber(line:match('^%s*%-%-(%d%d?)%-+'))
    if hour and hour >= 0 and hour <= 23 then
      if hour >= 1 and hour <= 8 then
        hour = hour + 12
      end
      local heading = { row = i - 1, hour = hour }
      if previous then
        previous.next_row = heading.row
      end
      result[#result + 1] = heading
      previous = heading
    elseif line:match('^%s*#+%s') then
      -- Notes and templates start separate sections, not extra task slots.
      previous = nil
    end
  end
  return result, lines
end

local function format_slots(buf)
  if not vim.bo[buf].modifiable or vim.bo[buf].readonly then
    return
  end
  local schedule, lines = headings(buf)
  local changed = false
  local overflow = false
  api.nvim_buf_call(buf, function()
    -- Work upwards so edits do not change the remaining heading positions.
    for i = #schedule, 1, -1 do
      local heading = schedule[i]
      if heading.next_row then
        local slots = {}
        for row = heading.row + 1, heading.next_row - 1 do
          slots[#slots + 1] = lines[row + 1]
        end
        local original_count = #slots
        for j = #slots, 1, -1 do
          if #slots > 2 and slots[j]:match('^%s*$') then
            table.remove(slots, j)
          end
        end
        if #slots > 2 then
          -- Never discard or combine task text to force it into two lines.
          overflow = true
        else
          while #slots < 2 do
            slots[#slots + 1] = ''
          end
          if original_count ~= #slots then
            if changed then
              vim.cmd('undojoin')
            end
            api.nvim_buf_set_lines(buf, heading.row + 1, heading.next_row, false, slots)
            changed = true
          end
        end
      end
    end
  end)
  if overflow then
    vim.notify('An hour has more than two task lines; kept them all. Use one line per 30-minute block.',
      vim.log.levels.WARN)
  end
end

local function refresh(buf)
  if not enabled[buf] or not api.nvim_buf_is_loaded(buf) then
    return
  end

  local now = os.date('*t')
  local label = string.format('◀ %d:%02d%s',
    (now.hour + 11) % 12 + 1, now.min, now.hour < 12 and 'AM' or 'PM')
  local row = 0
  local opts = { virt_text_pos = 'eol', priority = 200 }
  local matched = false
  for _, heading in ipairs(headings(buf)) do
    if heading.hour == now.hour and heading.next_row then
      local slot = now.min < 30 and 1 or 2
      -- While editing, spacing may be incomplete until the next save.
      row = math.min(heading.row + slot, heading.next_row - 1)
      opts.line_hl_group = 'ScheduleClockSlot'
      matched = true
      break
    end
  end
  if not matched then
    label = label .. ' (outside schedule)'
  end
  opts.virt_text = { { '  ' }, { label, 'ScheduleClockTime' } }
  api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  api.nvim_buf_set_extmark(buf, ns, row, 0, opts)
end

local function refresh_all()
  for buf in pairs(enabled) do
    refresh(buf)
  end
end

local function stop_timer()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

local function disable(buf)
  enabled[buf] = nil
  if api.nvim_buf_is_valid(buf) then
    api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  end
  if not next(enabled) then
    stop_timer()
  end
end

local function enable(buf)
  enabled[buf] = true
  refresh(buf)
  if not timer then
    timer = (vim.uv or vim.loop).new_timer()
    -- Refresh on the next minute boundary, then once each minute.
    timer:start((60 - os.date('*t').sec) * 1000, 60000, vim.schedule_wrap(refresh_all))
  end
end

api.nvim_create_user_command('ScheduleClock', function()
  local buf = api.nvim_get_current_buf()
  if enabled[buf] then
    disable(buf)
    vim.notify('Schedule clock off')
    return
  end
  if #headings(buf) == 0 then
    vim.notify('No schedule headings found (expected --9--, --10--, etc.)', vim.log.levels.WARN)
    return
  end

  enable(buf)
  vim.notify('Schedule clock on; :ScheduleClock toggles it off')
end, { desc = 'Toggle the current-time marker beside schedule hour headings' })

api.nvim_create_user_command('ScheduleSlots', function()
  local buf = api.nvim_get_current_buf()
  format_slots(buf)
  refresh(buf)
end, { desc = 'Make room for two 30-minute task lines between hour headings' })

api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
  group = group,
  pattern = 'today.md',
  callback = function(event)
    format_slots(event.buf)
    enable(event.buf)
  end,
})

api.nvim_create_autocmd('BufWritePre', {
  group = group,
  pattern = 'today.md',
  callback = function(event)
    format_slots(event.buf)
    refresh(event.buf)
  end,
})

api.nvim_create_autocmd({ 'BufEnter', 'TextChanged', 'TextChangedI', 'TextChangedP' }, {
  group = group,
  callback = function(event)
    refresh(event.buf)
  end,
})
api.nvim_create_autocmd({ 'FocusGained', 'VimResume' }, { group = group, callback = refresh_all })
api.nvim_create_autocmd({ 'BufUnload', 'BufWipeout' }, {
  group = group,
  callback = function(event)
    disable(event.buf)
  end,
})
api.nvim_create_autocmd('ColorScheme', { group = group, callback = highlights })
api.nvim_create_autocmd('VimLeavePre', { group = group, callback = stop_timer })
highlights()
