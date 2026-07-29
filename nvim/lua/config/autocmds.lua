local group = vim.api.nvim_create_augroup("MarkdownAiSuggestions", { clear = true })

local function disable_markdown_ai_suggestions(buf)
	if vim.bo[buf].filetype ~= "markdown" then
		return
	end

	vim.b[buf].sidekick_nes = false

	if vim.lsp.inline_completion then
		vim.lsp.inline_completion.enable(false, { bufnr = buf })
	end
end

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "markdown",
	callback = function(event)
		disable_markdown_ai_suggestions(event.buf)
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(event)
		disable_markdown_ai_suggestions(event.buf)
	end,
})
