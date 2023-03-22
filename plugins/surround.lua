return {
  "kylechui/nvim-surround",
  event = "User AstroFile",
  opts = {
    keymaps = {
      normal = "sa",
      normal_cur = "sv",
      normal_line = "ss",
      normal_curl_line = "sS",
      visual = "s",
      delete = "sd",
      change = "sr",
    },
    aliases = {
      ["u"] = { "}", "]", ")", ">", '"', "'", "`" },
    },
  },
}
