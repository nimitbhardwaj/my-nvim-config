return {
    "akinsho/bufferline.nvim",
    name="bufferline",
    config=function()
        require("bufferline").setup({
            options={
                mode="buffers",
                offsets={
                    {
                        filetype="NvimTree",
                        text="File Explorer",
                        highlight="Directory",
                        separator=true
                    }
                },
                numbers = function(opts)
                  return string.format('%s|%s', opts.id, opts.raise(opts.ordinal))
                end,
            }
        })
    end
}
