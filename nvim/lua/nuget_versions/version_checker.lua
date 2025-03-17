local ns_id = vim.api.nvim_create_namespace("nuget_versions")

-- Helper: find the line number where the package is mentioned.
local function find_line_for_package(package_name)
	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	for i, line in ipairs(lines) do
		if line:find(package_name) then
			return i - 1 -- convert to 0-indexed line number
		end
	end
	return nil
end

local function decode_json(obj)
	vim.schedule(function()
		-- check command execution
		if obj.code ~= 0 then
			vim.notify("Error running dotnet command: " .. obj.code .. " output: " .. obj.stderr, vim.log.levels.ERROR)
			return
		end

		-- Parse the json output
		local ok, data = pcall(vim.fn.json_decode, obj.stdout)
		if not ok or not data then
			vim.notify("NugetVersions: Failed to parse JSON", vim.log.levels.ERROR)
			return
		end

		vim.notify("NugetVersions: found " .. #data.projects .. " projects", vim.log.levels.INFO)

		-- Check for update presence
		for _, proj in ipairs(data.projects or {}) do
			if proj.frameworks then
				-- Check frameworks
				vim.notify("NugetVersions: found " .. #proj.frameworks .. " frameworks in project", vim.log.levels.INFO)

				for _, fwk in ipairs(proj.frameworks or {}) do
					local framework = fwk.framework
					vim.notify("NugetVersions: found updates for framework " .. framework, vim.log.levels.INFO)

					-- Check topLevelPackages to be updated
					for _, pkg in ipairs(fwk.topLevelPackages or {}) do
						local line = find_line_for_package(pkg.id)

						if line then
							local virt_text = { { " → " .. pkg.latestVersion, "WarningMsg" } }
							vim.api.nvim_buf_set_extmark(0, ns_id, line, 0, {
								virt_text = virt_text,
								virt_text_pos = "eol",
							})
						end
					end
				end
			end
		end
	end)
end

local function update_package()
	local buffer = vim.api.nvim_get_current_buf()
	local line_number = vim.api.nvim_win_get_cursor(0)[1] - 1 -- Get current line number (0-based)

	local extmark = vim.api.nvim_buf_get_extmarks(
		buffer,
		ns_id,
		{ line_number, 0 },
		{ line_number, -1 },
		{ details = false }
	)
	if #extmark > 0 then
		local csproj_path = vim.api.nvim_buf_get_name(0)
		local cmd = "dotnet"

		local line = vim.api.nvim_get_current_line()
		local include_value = line:match('Include="([^"]+)"')

		if include_value then
			local package_name = include_value

			vim.system({ cmd, "add", csproj_path, package_name })
		end
	end
end

local function check_outdated_background(csproj_path)
	local cmd = "dotnet"
	vim.system({ cmd, "list", csproj_path, "package", "--outdated", "--format", "json" }, { text = true }, decode_json)
end

-- Example: run the check when opening a csproj file.
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*.csproj",
	callback = function()
		local csproj_path = vim.api.nvim_buf_get_name(0)
		vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
		check_outdated_background(csproj_path)
	end,
})
