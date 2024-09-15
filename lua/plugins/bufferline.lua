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
                }
            }
        })
    end
}
