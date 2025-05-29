return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			strategies = {
				chat = {
					adapter = "ollama",
				},
				inline = {
					adapter = "ollama",
				},
			},

			opts = {
				log_level = "DEBUG",
			},

			display = {
				action_palette = {
					width = 80,
					height = 10,
					prompt = "~> ",
					provider = "telescope",
					opts = {
						show_default_actions = true,
						show_default_prompt_library = true,
					},
				},
			},

			adapters = {
				ollama = function()
					return require("codecompanion.adapters").extend("ollama", {
						schema = {
							model = {
								model = "gemma3:1.5b",
							},
						},
						env = {
							url = "http://" .. (vim.g.ollama_endpoint or "localhost") .. ":11434",
							api_key = "NONE",
						},
						headers = {
							["Content-Type"] = "application/json",
						},
						parameters = {
							sync = true,
						},
					})
				end
			},
		},
	},

	--[[ for when I'm working on non-confidential stuff
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
			},
			panel = {
				enabled = true,
				auto_trigger = true,
				debounce = 75,
				keymap = {
					accept = "<C-y>",
					refresh = "<C-Space>",
				},
			},
		},
	},

	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot-cmp" },
		event = { "InsertEnter", "LspAttach" },
		fix_pairs = true,
		config = function()
			require("copilot_cmp").setup()
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local buffer = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and (not "copilot" or client.name == "copilot") then
						return require("copilot_cmp")._on_insert_enter(client, buffer)
					end
				end,
			})

			--[[
			local cmp = require("cmp")
			local current_sources = cmp.get_config().sources or {}
			table.insert(current_sources, {
				name = "copilot",
				priority = 100,
			})

			cmp.setup({
				sources = current_sources
			})
			--
		end,
	},
	--]]

	--[=[ too custom for me rn, really I want more automatic stuff like copilot.lua
	{
		"frankroeder/parrot.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"ibhagwan/fzf-lua",
		},
		opts = {
			providers = {
				ollama = {
					endpoint = "http://" .. (vim.g.ollama_endpoint or "localhost") .. ":11434/api/chat",
				}
			},
			online_model_selection = true,
			command_auto_select_response = true,
			show_context_hints = true,
			per_symbol_delay = 20,
		},
		hooks = {
			Complete = function(prt, params)
				local template = [[
				I have the following code from {{filename}}:

				```{{filetype}}
				{{selection}}
				```

				Please finish the code above carefully and logically.
				Respond just with the snippet of code that should be inserted."
				]]
				local model_obj = prt.get_model "command"
				prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
			end,
			CompleteFullContext = function(prt, params)
				local template = [[
				I have the following code from {{filename}}:

				```{{filetype}}
				{{filecontent}}
				```

				Please look at the following section specifically:
				```{{filetype}}
				{{selection}}
				```

				Please finish the code above carefully and logically.
				Respond just with the snippet of code that should be inserted.
				]]
				local model_obj = prt.get_model "command"
				prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
			end,
			CompleteMultiContext = function(prt, params)
				local template = [[
				I have the following code from {{filename}} and other realted files:

				```{{filetype}}
				{{multifilecontent}}
				```

				Please look at the following section specifically:
				```{{filetype}}
				{{selection}}
				```

				Please finish the code above carefully and logically.
				Respond just with the snippet of code that should be inserted.
				]]
				local model_obj = prt.get_model "command"
				prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
			end,
			Explain = function(prt, params)
				local template = [[
				Your task is to take the code snippet from {{filename}} and explain it with gradually increasing complexity.
				Break down the code's functionality, purpose, and key components.
				The goal is to help the reader understand what the code does and how it works.

				```{{filetype}}
				{{selection}}
				```

				Use the markdown format with codeblocks and inline code.
				Explanation of the code above:
				]]
				local model = prt.get_model "command"
				prt.logger.info("Explaining selection with model: " .. model.name)
				prt.Prompt(params, prt.ui.Target.new, model, nil, template)
			end,
			FixBugs = function(prt, params)
				local template = [[
				You are an expert in {{filetype}}.
				Fix bugs in the below code from {{filename}} carefully and logically:
				Your task is to analyze the provided {{filetype}} code snippet, identify
				any bugs or errors present, and provide a corrected version of the code
				that resolves these issues. Explain the problems you found in the
				original code and how your fixes address them. The corrected code should
				be functional, efficient, and adhere to best practices in
				{{filetype}} programming.

				```{{filetype}}
				{{selection}}
				```

				Fixed code:
				]]
				local model_obj = prt.get_model "command"
				prt.logger.info("Fixing bugs in selection with model: " .. model_obj.name)
				prt.Prompt(params, prt.ui.Target.new, model_obj, nil, template)
			end,
			Optimize = function(prt, params)
				local template = [[
				You are an expert in {{filetype}}.
				Your task is to analyze the provided {{filetype}} code snippet and
				suggest improvements to optimize its performance. Identify areas
				where the code can be made more efficient, faster, or less
				resource-intensive. Provide specific suggestions for optimization,
				along with explanations of how these changes can enhance the code's
				performance. The optimized code should maintain the same functionality
				as the original code while demonstrating improved efficiency.

				```{{filetype}}
				{{selection}}
				```

				Optimized code:
				]]
				local model_obj = prt.get_model "command"
				prt.logger.info("Optimizing selection with model: " .. model_obj.name)
				prt.Prompt(params, prt.ui.Target.new, model_obj, nil, template)
			end,
			UnitTests = function(prt, params)
				local template = [[
				I have the following code from {{filename}}:

				```{{filetype}}
				{{selection}}
				```

				Please respond by writing table driven unit tests for the code above.
				]]
				local model_obj = prt.get_model "command"
				prt.logger.info("Creating unit tests for selection with model: " .. model_obj.name)
				prt.Prompt(params, prt.ui.Target.enew, model_obj, nil, template)
			end,
			Debug = function(prt, params)
				local template = [[
				I want you to act as {{filetype}} expert.
				Review the following code, carefully examine it, and report potential
				bugs and edge cases alongside solutions to resolve them.
				Keep your explanation short and to the point:

				```{{filetype}}
				{{selection}}
				```
				]]
				local model_obj = prt.get_model "command"
				prt.logger.info("Debugging selection with model: " .. model_obj.name)
				prt.Prompt(params, prt.ui.Target.enew, model_obj, nil, template)
			end,
			CommitMsg = function(prt, params)
				local futils = require "parrot.file_utils"
				if futils.find_git_root() == "" then
					prt.logger.warning "Not in a git repository"
					return
				else
					local template = [[
					I want you to act as a commit message generator. I will provide you
					with information about the task and the prefix for the task code, and
					I would like you to generate an appropriate commit message using the
					conventional commit format. Do not write any explanations or other
					words, just reply with the commit message.
					Start with a short headline as summary but then list the individual
					changes in more detail.

					Here are the changes that should be considered by this message:
					]] .. vim.fn.system "git diff --no-color --no-ext-diff --staged"
					local model_obj = prt.get_model "command"
					prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
				end
			end,
			SpellCheck = function(prt, params)
				local chat_prompt = [[
				Your task is to take the text provided and rewrite it into a clear,
				grammatically correct version while preserving the original meaning
				as closely as possible. Correct any spelling mistakes, punctuation
				errors, verb tense issues, word choice problems, and other
				grammatical mistakes.
				]]
				prt.ChatNew(params, chat_prompt)
			end,
			CodeConsultant = function(prt, params)
				local chat_prompt = [[
				Your task is to analyze the provided {{filetype}} code and suggest
				improvements to optimize its performance. Identify areas where the
				code can be made more efficient, faster, or less resource-intensive.
				Provide specific suggestions for optimization, along with explanations
				of how these changes can enhance the code's performance. The optimized
				code should maintain the same functionality as the original code while
				demonstrating improved efficiency.

				Here is the code
				```{{filetype}}
				{{filecontent}}
				```
				]]
				prt.ChatNew(params, chat_prompt)
			end,
			ProofReader = function(prt, params)
				local chat_prompt = [[
				I want you to act as a proofreader. I will provide you with texts and
				I would like you to review them for any spelling, grammar, or
				punctuation errors. Once you have finished reviewing the text,
				provide me with any necessary corrections or suggestions to improve the
				text. Highlight the corrected fragments (if any) using markdown backticks.

				When you have done that subsequently provide me with a slightly better
				version of the text, but keep close to the original text.

				Finally provide me with an ideal version of the text.

				Whenever I provide you with text, you reply in this format directly:

				## Corrected text:

				{corrected text, or say "NO_CORRECTIONS_NEEDED" instead if there are no corrections made}

				## Slightly better text

				{slightly better text}

				## Ideal text

				{ideal text}
				]]
				prt.ChatNew(params, chat_prompt)
			end,
		},
		keys = {
			{ "<C-g>pcn", "<cmd>PrtChatNew<cr>", mode = { "n", "i" }, desc = "New Chat" },
			{ "<C-g>pcn", ":<C-u>'<,'>PrtChatNew<cr>", mode = { "v" }, desc = "Visual Chat New" },
			{ "<C-g>pct", "<cmd>PrtChatToggle<cr>", mode = { "n", "i" }, desc = "Toggle Popup Chat" },
			{ "<C-g>pcf", "<cmd>PrtChatFinder<cr>", mode = { "n", "i" }, desc = "Chat Finder" },
			{ "<C-g>pir", "<cmd>PrtRewrite<cr>", mode = { "n", "i" }, desc = "Inline Rewrite" },
			{ "<C-g>pir", ":<C-u>'<,'>PrtRewrite<cr>", mode = { "v" }, desc = "Visual Rewrite" },
			{ "<C-g>pr", "<cmd>PrtRetry<cr>", mode = { "n" }, desc = "Retry rewrite/append/prepend command" },
			{ "<C-g>pa", "<cmd>PrtAppend<cr>", mode = { "n", "i" }, desc = "Append" },
			{ "<C-g>pa", ":<C-u>'<,'>PrtAppend<cr>", mode = { "v" }, desc = "Visual Append" },
			{ "<C-g>pp", "<cmd>PrtPrepend<cr>", mode = { "n", "i" }, desc = "Prepend" },
			{ "<C-g>pp", ":<C-u>'<,'>PrtPrepend<cr>", mode = { "v" }, desc = "Visual Prepend" },
			{ "<C-g>pe", ":<C-u>'<,'>PrtEnew<cr>", mode = { "v" }, desc = "Visual Enew" },
			{ "<C-g>ps", "<cmd>PrtStop<cr>", mode = { "n", "i", "v", "x" }, desc = "Stop" },
			{ "<C-g>pce", ":<C-u>'<,'>PrtComplete<cr>", mode = { "n", "i", "v", "x" }, desc = "Complete visual selection" },
			{ "<C-g>pcf", "<cmd>PrtContext<cr>", mode = { "n" }, desc = "Open context file" },
			{ "<C-g>pm", "<cmd>PrtModel<cr>", mode = { "n" }, desc = "Select model" },
			{ "<C-g>pz", "<cmd>PrtProvider<cr>", mode = { "n" }, desc = "Select provider" },
			{ "<C-g>pq", "<cmd>PrtAsk<cr>", mode = { "n" }, desc = "Ask a question" },
		},
	},
	--]=]

}
