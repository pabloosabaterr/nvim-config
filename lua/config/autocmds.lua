local group = vim.api.nvim_create_augroup("user", { clear = true })
local au = function(event, opts)
	opts.group = group
	vim.api.nvim_create_autocmd(event, opts)
end

-- Recargar ficheros cambiados fuera de nvim
au({ "FocusGained", "BufEnter", "CursorHold" }, {
	callback = function()
		if vim.fn.mode() ~= "c" then
			vim.cmd.checktime()
		end
	end,
})

-- Resaltar lo copiado
au("TextYankPost", {
	callback = function()
		vim.hl.on_yank({ timeout = 150 })
	end,
})

-- Git commit
au("FileType", {
	pattern = "gitcommit",
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_us"
		vim.fn.matchadd("ColorColumn", [[\%1l.\{50,\}]], 100)
	end,
})
au("BufEnter", {
	pattern = "COMMIT_EDITMSG",
	callback = function()
		if vim.fn.getline(1) == "" then
			vim.cmd.startinsert()
		end
	end,
})

-- Markdown
au("FileType", {
	pattern = "markdown",
	callback = function(ev)
		local l = vim.opt_local
		l.wrap = true
		l.linebreak = true
		l.breakindent = true
		l.conceallevel = 2
		l.concealcursor = ""
		l.spell = true
		l.spelllang = "en_us"
		l.textwidth = 0
		l.shiftwidth = 2
		l.tabstop = 2
		l.expandtab = true
		local o = { buffer = ev.buf }
		vim.keymap.set("n", "j", "gj", o)
		vim.keymap.set("n", "k", "gk", o)
		vim.keymap.set(
			"n",
			"<leader>mr",
			"<cmd>RenderMarkdown toggle<CR>",
			{ buffer = ev.buf, desc = "Render markdown" }
		)
	end,
})

-- ARM64
vim.filetype.add({
	extension = { s = "arm64asm", S = "arm64asm", gotmpl = "gotmpl" },
})
au("FileType", {
	pattern = "arm64asm",
	callback = function()
		vim.cmd([[
      syntax match arm64asmLineComment "//.*$" contains=@Spell
      highlight default link arm64asmLineComment Comment
    ]])
		vim.bo.commentstring = "// %s"
	end,
})
