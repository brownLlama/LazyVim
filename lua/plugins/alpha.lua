-- Welcome screen
return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  enabled = true,
  init = false,
  opts = function()
    local dashboard = require("alpha.themes.dashboard")
    local logo = [[
                                              ~)
                                              (_---;
                                              /|~|\
                                              / / /|
      ██████╗ ██████╗  ██████╗ ██╗    ██╗███╗   ██╗
      ██╔══██╗██╔══██╗██╔═══██╗██║    ██║████╗  ██║ 
      ██████╔╝██████╔╝██║   ██║██║ █╗ ██║██╔██╗ ██║
      ██╔══██╗██╔══██╗██║   ██║██║███╗██║██║╚██╗██║
      ██████╔╝██║  ██║╚██████╔╝╚███╔███╔╝██║ ╚████║
      ╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═══╝
      
      ██╗     ██╗      █████╗ ███╗   ███╗ █████╗
      ██║     ██║     ██╔══██╗████╗ ████║██╔══██╗
      ██║     ██║     ███████║██╔████╔██║███████║
      ██║     ██║     ██╔══██║██║╚██╔╝██║██╔══██║
      ███████╗███████╗██║  ██║██║ ╚═╝ ██║██║  ██║
      ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝
    ]]

    dashboard.section.header.val = vim.split(logo, "\n")
    -- stylua: ignore
    dashboard.section.buttons.val = {
      dashboard.button("f", " " .. " Find file",       LazyVim.pick()),
      dashboard.button("g", " " .. " Find text",       LazyVim.pick("live_grep")),
      dashboard.button("q", " " .. " Quit",            "<cmd> qa <cr>"),
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end
    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"
    dashboard.opts.layout[1].val = 8
    return dashboard
  end,
  config = function(_, dashboard)
    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "AlphaReady",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    require("alpha").setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
      once = true,
      pattern = "LazyVimStarted",
      callback = function()
        dashboard.section.footer.val = "⚡ Ever met a llama with a good sense of personal space? Me neither ⚡"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
