return {
  "vuki656/package-info.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  config = function()
    local package_info = require("package-info")
    package_info.setup()

    -- Show dependency versions
    vim.keymap.set({ "n" }, "<LEADER>ns", package_info.show, { silent = true, noremap = true })

    -- Hide dependency versions
    vim.keymap.set({ "n" }, "<LEADER>nc", package_info.hide, { silent = true, noremap = true })

    -- Toggle dependency versions
    vim.keymap.set({ "n" }, "<LEADER>nt", package_info.toggle, { silent = true, noremap = true })

    -- Update dependency on the line
    vim.keymap.set({ "n" }, "<LEADER>nu", package_info.update, { silent = true, noremap = true })

    -- Delete dependency on the line
    vim.keymap.set({ "n" }, "<LEADER>nd", package_info.delete, { silent = true, noremap = true })

    -- Install a new dependency
    vim.keymap.set({ "n" }, "<LEADER>ni", package_info.install, { silent = true, noremap = true })

    -- Install a different dependency version
    vim.keymap.set({ "n" }, "<LEADER>np", package_info.change_version, { silent = true, noremap = true })
  end
}
