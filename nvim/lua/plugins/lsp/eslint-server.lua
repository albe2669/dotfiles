local E = {
    setup = function(on_attach)
        local lspconfig = require("lspconfig")

        lspconfig["eslint"].setup({
            root_dir = lspconfig.util.root_pattern(".eslintrc", ".eslintrc.js"),
            on_attach = function(client, bufnr)
                client.resolved_capabilities.document_formatting = true
                on_attach(client, bufnr)
            end,
            settings = {
                format = {
                    enable = true,
                },
            },
        })
    end,
}

return E
