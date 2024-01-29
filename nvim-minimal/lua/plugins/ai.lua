return {
	{
		"dustinblackman/oatmeal.nvim",
		cmd = { "Oatmeal" },
		keys = {
			{ "<leader>om", mode = "n", desc = "Start Oatmeal session" },
		},
		opts = {
			backend = "ollama",
			model = "codellama:latest",
		},
	},
	--ai
	{
		"David-Kunz/gen.nvim",
		config = function()
			local gen = require("gen")
			gen.model = "codellama:13b-instruct"
			gen.prompts["Fix_Code"] = {
				prompt = "Fix the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
				replace = true,
				extract = "```$filetype\n(.-)```",
			}
		end,
	},
	{
		"jackMort/ChatGPT.nvim",
		event = "VeryLazy",
		config = function()
			require("chatgpt").setup({
				yank_register = "+",
				edit_with_instructions = {
					diff = false,
					keymaps = {
						close = "<C-c>",
						accept = "<C-y>",
						toggle_diff = "<C-d>",
						toggle_settings = "<C-o>",
						cycle_windows = "<Tab>",
						use_output_as_input = "<C-i>",
					},
				},
				chat = {
					welcome_message = "What do you want?",
					loading_text = "Loading, please wait ...",
					question_sign = "", -- 🙂
					answer_sign = "ﮧ", -- 🤖
					max_line_length = 120,
					sessions_window = {
						border = {
							style = "rounded",
							text = {
								top = " Sessions ",
							},
						},
						win_options = {
							winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
						},
					},
					keymaps = {
						close = { "<C-c>" },
						yank_last = "<C-y>",
						yank_last_code = "<C-k>",
						scroll_up = "<C-u>",
						scroll_down = "<C-d>",
						new_session = "<C-n>",
						cycle_windows = "<Tab>",
						cycle_modes = "<C-f>",
						next_message = "<C-j>",
						prev_message = "<C-k>",
						select_session = "<Space>",
						rename_session = "r",
						delete_session = "d",
						draft_message = "<C-d>",
						edit_message = "e",
						delete_message = "d",
						toggle_settings = "<C-o>",
						toggle_message_role = "<C-r>",
						toggle_system_role_open = "<C-s>",
						stop_generating = "<C-x>",
					},
				},
				popup_layout = {
					default = "center",
					center = {
						width = "80%",
						height = "80%",
					},
					right = {
						width = "30%",
						width_settings_open = "50%",
					},
				},
				popup_window = {
					border = {
						highlight = "FloatBorder",
						style = "rounded",
						text = {
							top = " ChatGPT ",
						},
					},
					win_options = {
						wrap = true,
						linebreak = true,
						foldcolumn = "1",
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
					},
					buf_options = {
						filetype = "markdown",
					},
				},
				system_window = {
					border = {
						highlight = "FloatBorder",
						style = "rounded",
						text = {
							top = " SYSTEM ",
						},
					},
					win_options = {
						wrap = true,
						linebreak = true,
						foldcolumn = "2",
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
					},
				},
				popup_input = {
					prompt = "  ",
					border = {
						highlight = "FloatBorder",
						style = "rounded",
						text = {
							top_align = "center",
							top = " Prompt ",
						},
					},
					win_options = {
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
					},
					submit = "<C-Enter>",
					submit_n = "<Enter>",
					max_visible_lines = 20,
				},
				settings_window = {
					border = {
						style = "rounded",
						text = {
							top = " Settings ",
						},
					},
					win_options = {
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
					},
				},
				openai_params = {
					model = "gpt-3.5-turbo",
					-- model = "gpt-4",
					frequency_penalty = 0,
					presence_penalty = 0,
					max_tokens = 3000,
					temperature = 0,
					top_p = 1,
					n = 1,
				},
				openai_edit_params = {
					model = "gpt-3.5-turbo",
					frequency_penalty = 0,
					presence_penalty = 0,
					temperature = 0,
					top_p = 1,
					n = 1,
				},
				use_openai_functions_for_edits = false,
				actions_paths = {},
				show_quickfixes_cmd = "Trouble quickfix",
				predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
			})
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
	{
		"piersolenski/wtf.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"gw",
				mode = { "n" },
				function()
					require("wtf").ai()
				end,
				desc = "Debug diagnostic with AI",
			},
			{
				mode = { "n" },
				"gW",
				function()
					require("wtf").search()
				end,
				desc = "Search diagnostic with Google",
			},
		},
	},
	-- copilot
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				filetypes = {
					yaml = false,
					markdown = false,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					go = false,
					rust = false,
					elixir = false,
					["."] = true,
				},
				panel = {
					enabled = true,
				},
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = "<C-e>",
						accept_word = false,
						accept_line = false,
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
			})
		end,
	},
}
