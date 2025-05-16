return {
  "Kurama622/llm.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "echasnovski/mini.nvim" },
  cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
  config = function()
    local tools = require("llm.tools")
    require("llm").setup({
      url = "http://localhost:11434/api/chat",
      model = "codellama",
      api_type = "ollama",

      -- display diff [require by action_handler]
      display = {
        diff = {
          layout = "vertical",    -- vertical|horizontal split for default provider
          opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
          provider = "mini_diff", -- default|mini_diff
        },
      },
      app_handler = {
        CommitMsg = {
          handler = tools.flexi_handler,
          prompt = function()
            -- Source: https://andrewian.dev/blog/ai-git-commits
            return string.format(
              "You are an expert at following the Conventional Commit specification.\n" ..
              "Given the git diff listed below, please generate a commit message for me using the Conventional Commit specification in the first line.\n" ..
              "1. First line: conventional commit format (type: concise description) (remember to use semantic types like feat, fix, docs, style, refactor, perf, test, chore, etc.).\n" ..
              "2. Optional bullet points if more context helps:\n" ..
              "- Keep the second line blank\n" ..
              "- Keep them short and direct\n" ..
              "- Focus on what changed\n" ..
              "- Always be terse\n" ..
              "- Don't overly explain\n" ..
              "- Drop any fluffy or formal language\n" ..
              "Return ONLY the commit message - no introduction, no explanation, no quotes around it.\n" ..
              "Based on this format, generate appropriate commit messages. Respond with message only. DO NOT format the message in Markdown code blocks, DO NOT use backticks:\n" ..
              "\n ```diff\n%s\n```",
              vim.fn.system("git diff --no-ext-diff --staged")
            )
          end,

          opts = {
            enter_flexible_window = true,
            apply_visual_selection = false,
            win_opts = {
              relative = "editor",
              position = "50%",
            },
            accept = {
              mapping = {
                mode = "n",
                keys = "<cr>",
              },
              action = function()
                local contents = vim.api.nvim_buf_get_lines(0, 0, -1, true)
                vim.api.nvim_command(string.format('Git commit -m "%s"', table.concat(contents, '" -m "')))
              end,
            },
          },
        },
        Ask = {
          handler = tools.disposable_ask_handler,
          opts = {
            position = {
              row = 2,
              col = 0,
            },
            title = " Ask ",
            inline_assistant = true,

            -- display diff
            display = {
              mapping = {
                mode = "n",
                keys = { "d" },
              },
              action = nil,
            },
            -- accept diff
            accept = {
              mapping = {
                mode = "n",
                keys = { "Y", "y" },
              },
              action = nil,
            },
            -- reject diff
            reject = {
              mapping = {
                mode = "n",
                keys = { "N", "n" },
              },
              action = nil,
            },
            -- close diff
            close = {
              mapping = {
                mode = "n",
                keys = { "<esc>" },
              },
              action = nil,
            },
          },
        },
      },
    })
  end,
  keys = {
    { "<leader>ac", mode = "n", "<cmd>LLMSessionToggle<cr>" },
  },
}
