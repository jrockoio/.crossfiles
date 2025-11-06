-- -----------------------------------------------------------------
-- Configuration for GitHub Copilot (Completions)
-- This section seems to be for copilot.lua or copilot.vim
-- and is not related to CopilotChat. It should be fine to keep.
-- -----------------------------------------------------------------
vim.api.nvim_set_keymap("i", "<C-]>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
-- alt n
vim.keymap.set("i", "˜", '<Plug>(copilot-next)')
-- alt p
vim.keymap.set("i", "π", '<Plug>(copilot-previous)')

vim.g.copilot_no_tab_map = true

-- -----------------------------------------------------------------
-- Configuration for CopilotChat.nvim
-- -----------------------------------------------------------------
require("CopilotChat").setup {
  debug = false, -- Enable debugging
  auto_insert_mode = true,
  -- Note: You may need to set up a default UI select if you want
  -- fzf-lua for all pickers. For example:
  -- vim.ui.select = require('fzf-lua').register_ui_select()
}


-- -----------------
-- CopilotChat Keymaps
-- -----------------

-- [REPLACED] Keymap for prompts (e.g., Explain, Fix, Optimize)
-- This now uses the built-in :CopilotChatPrompts command.
vim.keymap.set({ "n", "v" }, "<leader>cp", "<cmd>CopilotChatPrompts<CR>", {
  desc = "CopilotChat - Show prompts"
})

-- Toggles Chat
vim.keymap.set({ "n" }, "<leader>ct", "<cmd>CopilotChat<CR>", {
  desc = "CopilotChat - Chat with current line"
})

-- [UPDATED] Chat with visual selection (Visual Mode)
-- This now uses the built-in :CopilotChat command
vim.keymap.set({ "v" }, "<leader>ct", "<cmd>CopilotChat<CR>", {
  desc = "CopilotChat - Chat with selection"
})

-- [UPDATED] Chat with entire buffer
-- Selects the whole buffer and opens chat
vim.keymap.set({ "n" }, "<leader>cb", "ggVG<cmd>CopilotChat<CR>", {
  desc = "CopilotChat - Chat with buffer"
})

-- -----------------------------------------------------------------
-- Custom Function: Chat with selected files using fzf-lua
-- [This has been completely rewritten to use the new #file resource]
-- -----------------------------------------------------------------

-- Function to select files using fzf-lua and initiate CopilotChat
local function select_files_and_chat()
  require('fzf-lua').files({
    fzf_cli_args = "-i", -- Case-insensitive search
    actions = {
      -- Use "default" for Enter key
      ["default"] = function(selected)
        if not selected or #selected == 0 then
          print("[CopilotChat] No files selected.")
          return
        end

        -- Build a prompt string made of #file resources
        local prompt_parts = {}
        for _, file_path in ipairs(selected) do
          -- The #file resource works with relative or absolute paths
          table.insert(prompt_parts, "#file:" .. file_path)
        end

        local prompt = table.concat(prompt_parts, " ")

        -- Open CopilotChat with the selected files as context
        -- The user can then type their question.
        vim.cmd("CopilotChat " .. prompt)
      end
    }
  })
end

-- Key mapping to select files and chat
vim.keymap.set({ "n" }, "<leader>cf", select_files_and_chat, {
  desc = "CopilotChat - Select files to chat with"
})
