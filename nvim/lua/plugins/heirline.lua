return {
	"rebelot/heirline.nvim",
    dependencies = {
		"nvim-tree/nvim-web-devicons",
		"lewis6991/gitsigns.nvim",
	},
	config = function()
		local conditions = require("heirline.conditions")
		local utils = require("heirline.utils")

		-- Setup colors inspired by NvChad
		local function setup_colors()
			return {
				bg = utils.get_highlight("StatusLine").bg,
				fg = utils.get_highlight("StatusLine").fg,

				-- Mode colors
				red = "#e55561",
				dark_red = "#8b3434",
				green = "#8ebd6b",
				blue = "#4fa6ed",
				cyan = "#48b0bd",
				purple = "#bf68d9",
				orange = "#e2a478",
				yellow = "#e2b86b",

				-- Semantic colors
				gray = "#7e8294",
				bright_bg = "#30323a",
				light_gray = "#52545d",

				-- Diagnostic colors
				diag_error = utils.get_highlight("DiagnosticError").fg,
				diag_warn = utils.get_highlight("DiagnosticWarn").fg,
				diag_info = utils.get_highlight("DiagnosticInfo").fg,
				diag_hint = utils.get_highlight("DiagnosticHint").fg,

				-- Git colors
				git_add = "#8ebd6b",
				git_change = "#e2b86b",
				git_del = "#e55561",
			}
		end

		require("heirline").load_colors(setup_colors)

		-- Utility components
		local Space = { provider = " " }
		local Align = { provider = "%=" }

		-- Vi Mode Component (NvChad style with rounded separators)
		local ViMode = {
			init = function(self)
				self.mode = vim.fn.mode(1)
			end,
			static = {
				mode_names = {
					n = "NORMAL",
					no = "O-PENDING",
					nov = "O-PENDING",
					noV = "O-PENDING",
					["no\22"] = "O-PENDING",
					niI = "NORMAL",
					niR = "NORMAL",
					niV = "NORMAL",
					nt = "NORMAL",
					v = "VISUAL",
					vs = "VISUAL",
					V = "V-LINE",
					Vs = "V-LINE",
					["\22"] = "V-BLOCK",
					["\22s"] = "V-BLOCK",
					s = "SELECT",
					S = "S-LINE",
					["\19"] = "S-BLOCK",
					i = "INSERT",
					ic = "INSERT",
					ix = "INSERT",
					R = "REPLACE",
					Rc = "REPLACE",
					Rx = "REPLACE",
					Rv = "V-REPLACE",
					Rvc = "V-REPLACE",
					Rvx = "V-REPLACE",
					c = "COMMAND",
					cv = "EX",
					r = "...",
					rm = "MORE",
					["r?"] = "CONFIRM",
					["!"] = "SHELL",
					t = "TERMINAL",
				},
				mode_colors = {
					n = "blue",
					i = "green",
					v = "purple",
					V = "purple",
					["\22"] = "purple",
					c = "orange",
					s = "purple",
					S = "purple",
					["\19"] = "purple",
					R = "red",
					r = "red",
					["!"] = "red",
					t = "green",
				},
			},
			{
				provider = "█",
				hl = function(self)
					local mode = self.mode:sub(1, 1)
					return { fg = self.mode_colors[mode] }
				end,
			},
			{
				provider = function(self)
					return " " .. self.mode_names[self.mode] .. " "
				end,
				hl = function(self)
					local mode = self.mode:sub(1, 1)
					return { bg = self.mode_colors[mode], fg = "bg", bold = true }
				end,
			},
			{
				provider = "",
				hl = function(self)
					local mode = self.mode:sub(1, 1)
					return { fg = self.mode_colors[mode], bg = "bright_bg" }
				end,
			},
			update = {
				"ModeChanged",
				pattern = "*:*",
				callback = vim.schedule_wrap(function()
					vim.cmd("redrawstatus")
				end),
			},
		}

		-- File info section
		local FileIcon = {
			init = function(self)
				local filename = self.filename
				local extension = vim.fn.fnamemodify(filename, ":e")
				self.icon, self.icon_color =
					require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
			end,
			provider = function(self)
				return self.icon and (self.icon .. " ")
			end,
			hl = function(self)
				return { fg = self.icon_color, bg = "bright_bg" }
			end,
		}

		local FileName = {
			init = function(self)
				self.filename = vim.api.nvim_buf_get_name(0)
			end,
			provider = function(self)
				local filename = vim.fn.fnamemodify(self.filename, ":.")
				if filename == "" then
					return "[No Name]"
				end
				if not conditions.width_percent_below(#filename, 0.25) then
					filename = vim.fn.pathshorten(filename)
				end
				return filename
			end,
			hl = { fg = "fg", bg = "bright_bg" },
		}

		local FileFlags = {
			{
				condition = function()
					return vim.bo.modified
				end,
				provider = " ●",
				hl = { fg = "green", bg = "bright_bg" },
			},
			{
				condition = function()
					return not vim.bo.modifiable or vim.bo.readonly
				end,
				provider = " ",
				hl = { fg = "orange", bg = "bright_bg" },
			},
		}

		local FileNameBlock = {
			init = function(self)
				self.filename = vim.api.nvim_buf_get_name(0)
			end,
			hl = { bg = "bright_bg" },
			Space,
			FileIcon,
			FileName,
			FileFlags,
			Space,
			{
				provider = "",
				hl = { fg = "bright_bg" },
			},
		}

		-- Git Component
		local Git = {
			condition = conditions.is_git_repo,
			init = function(self)
				self.status_dict = vim.b.gitsigns_status_dict
				self.has_changes = self.status_dict.added ~= 0
					or self.status_dict.removed ~= 0
					or self.status_dict.changed ~= 0
			end,
			Space,
			{
				provider = function(self)
					return "  " .. self.status_dict.head
				end,
				hl = { fg = "purple", bold = true },
			},
			{
				condition = function(self)
					return self.has_changes
				end,
				provider = " ",
			},
			{
				provider = function(self)
					local count = self.status_dict.added or 0
					return count > 0 and (" " .. count)
				end,
				hl = { fg = "git_add" },
			},
			{
				provider = function(self)
					local count = self.status_dict.changed or 0
					return count > 0 and (" " .. count)
				end,
				hl = { fg = "git_change" },
			},
			{
				provider = function(self)
					local count = self.status_dict.removed or 0
					return count > 0 and (" " .. count)
				end,
				hl = { fg = "git_del" },
			},
			Space,
		}

		-- LSP Active indicator
		local LSPActive = {
			condition = conditions.lsp_attached,
			update = { "LspAttach", "LspDetach" },
			provider = function()
				local names = {}
				for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
					table.insert(names, server.name)
				end
				return "  " .. table.concat(names, ", ") .. " "
			end,
			hl = { fg = "green" },
		}

		-- Diagnostics
		local Diagnostics = {
			condition = conditions.has_diagnostics,
			static = {
				error_icon = " ",
				warn_icon = " ",
				info_icon = " ",
				hint_icon = " ",
			},
			init = function(self)
				self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
				self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
				self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
				self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
			end,
			update = { "DiagnosticChanged", "BufEnter" },
			{
				provider = function(self)
					return self.errors > 0 and (self.error_icon .. self.errors .. " ")
				end,
				hl = { fg = "diag_error" },
			},
			{
				provider = function(self)
					return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
				end,
				hl = { fg = "diag_warn" },
			},
			{
				provider = function(self)
					return self.info > 0 and (self.info_icon .. self.info .. " ")
				end,
				hl = { fg = "diag_info" },
			},
			{
				provider = function(self)
					return self.hints > 0 and (self.hint_icon .. self.hints .. " ")
				end,
				hl = { fg = "diag_hint" },
			},
		}

		-- File info (right side)
		local FileType = {
			provider = function()
				return vim.bo.filetype ~= "" and "  " .. vim.bo.filetype .. " " or ""
			end,
			hl = { fg = "fg" },
		}

		local FileEncoding = {
			provider = function()
				local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
				return enc ~= "utf-8" and (enc:upper() .. " ") or ""
			end,
			hl = { fg = "gray" },
		}

		local Ruler = {
			provider = " %l:%c %P ",
			hl = { fg = "fg" },
		}

		local ScrollBar = {
			static = {
				sbar = { "█", "▇", "▆", "▅", "▄", "▃", "▂", "▁" },
			},
			provider = function(self)
				local curr_line = vim.api.nvim_win_get_cursor(0)[1]
				local lines = vim.api.nvim_buf_line_count(0)
				local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
				return self.sbar[i]
			end,
			hl = { fg = "blue", bg = "bright_bg" },
		}

		local RightSection = {
			{
				provider = "",
				hl = { fg = "bright_bg" },
			},
			hl = { bg = "bright_bg" },
			Space,
			FileType,
			FileEncoding,
			Ruler,
			ScrollBar,
			Space,
		}

		-- Assemble the statusline
		local DefaultStatusline = {
			ViMode,
			FileNameBlock,
			Space,
			Git,
			Diagnostics,
			Align,
			LSPActive,
			RightSection,
		}

		local InactiveStatusline = {
			condition = conditions.is_not_active,
			Space,
			FileNameBlock,
			Align,
		}

		local SpecialStatusline = {
			condition = function()
				return conditions.buffer_matches({
					buftype = { "nofile", "prompt", "help", "quickfix" },
					filetype = { "^git.*", "fugitive" },
				})
			end,
			Space,
			FileType,
			Align,
		}

		local TerminalStatusline = {
			condition = function()
				return conditions.buffer_matches({ buftype = { "terminal" } })
			end,
			ViMode,
			Space,
			{
				provider = function()
					local tname = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
					return "  " .. tname
				end,
				hl = { fg = "cyan", bold = true },
			},
			Align,
		}

		local StatusLines = {
			fallthrough = false,
			SpecialStatusline,
			TerminalStatusline,
			InactiveStatusline,
			DefaultStatusline,
		}

		-- Setup Heirline
		require("heirline").setup({
			statusline = StatusLines,
			opts = {
				colors = setup_colors,
			},
		})

		-- Auto-update colors on colorscheme change
		vim.api.nvim_create_augroup("Heirline", { clear = true })
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				utils.on_colorscheme(setup_colors)
			end,
			group = "Heirline",
		})
	end,
}
