vim.api.nvim_set_keymap("i", "<C-]>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
-- alt n
vim.keymap.set("i", "˜", '<Plug>(copilot-next)')
-- alt p
vim.keymap.set("i", "π", '<Plug>(copilot-previous)')

vim.g.copilot_no_tab_map = true

require("CopilotChat").setup {
  debug = false, -- Enable debugging
  auto_insert_mode = false
  -- See Configuration section for rest
}

local opts = { noremap = true, silent = true }

local chat = require('CopilotChat')
local actions = require('CopilotChat.actions')
local integration = require('CopilotChat.integrations.fzflua')

local function pick(pick_actions)
  return function()
    integration.pick(pick_actions(), {
      fzf_tmux_opts = {
        ['-d'] = '45%',
      },
    })
  end
end

--copilot chat
vim.keymap.set({ "n", "v" }, "<leader>cp", pick(actions.prompt_actions), opts)
vim.keymap.set({ "n" }, "<leader>ct", function()
  vim.cmd('normal! V') -- Select the current line
  chat.open()
  vim.cmd('startinsert')
end, { desc = 'Normal Chat' })
vim.keymap.set({ "v" }, "<leader>ct", function()
  chat.open()
  vim.cmd('startinsert')
end, { desc = 'Normal Chat' })
vim.keymap.set({ "n" }, "<leader>cb",
  function()
    vim.cmd('normal! ggVG') -- select entire buffer
    vim.cmd('CopilotChat')
    vim.cmd('startinsert')
  end,
  { desc = "Buffer Chat" }
)

-- Using FZF to select files and chat --

-- Function to read the content of a file
local function read_file(file_path)
  local file = io.open(file_path, "r")
  if not file then return nil end
  local content = file:read("*all")
  file:close()
  return content
end

-- Function to gather content from multiple files
local function gather_files_content(file_paths)
  local content = ""
  for _, file_path in ipairs(file_paths) do
    local file_content = read_file(file_path)
    if file_content then
      content = content .. "\n" .. file_content
    end
  end
  return content
end

-- Custom function to initiate CopilotChat with multiple files' content
local function copilot_chat_with_files(file_paths)
  local content = gather_files_content(file_paths)
  print("content:", content)
  if content and #content > 0 then
    vim.cmd('CopilotChat')      -- Start CopilotChat
    vim.fn.setreg('"', content) -- Set the gathered content to the default register
    vim.cmd('normal! "P')       -- Paste the content into the chat
    vim.cmd('startinsert')      -- Start insert mode
  end
end

-- Function to select files using fzf-lua and initiate CopilotChat
local function select_files_and_chat()
  print("select_files_and_chat")
  require('fzf-lua').files({
    fzf_cli_args = "-i", -- Case-insensitive search
    actions = {
      ["default"] = function(selected)
        print("selected:", vim.inspect(selected))
        copilot_chat_with_files(selected)
      end
    }
  })
end

-- Key mapping to select files and chat
vim.keymap.set({ "n" }, "<leader>cf",
  select_files_and_chat, { desc = "Select Files and Chat" })
