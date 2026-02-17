return {
  -- SKK Japanese input for Neovim
  {
    "vim-skk/skkeleton",
    dependencies = {
      "vim-denops/denops.vim",
    },
    lazy = false, -- 起動時に読み込む
    config = function()
      -- SKKeletonの基本設定
      vim.fn["skkeleton#config"]({
        globalDictionaries = {
          vim.fn.expand("~/.config/skk/SKK-JISYO.L"),
        },
        userDictionary = vim.fn.expand("~/.config/skk/user-dictionary"),
        eggLikeNewline = true, -- 変換確定時の改行挙動
        keepState = true, -- 入力モードを保持
        showCandidatesCount = 4, -- 候補表示数
        immediatelyCancel = false, -- ESCですぐにキャンセル
      })

      -- 辞書登録
      vim.fn["skkeleton#register_kanatable"]("rom", {
        ["z,"] = {"←"},
        ["z."] = {"→"},
        ["z["] = {"『"},
        ["z]"] = {"』"},
      })
      
      -- Keymaps are now centralized in lua/config/keymaps.lua
    end,
  },

  -- Denops (required for skkeleton)
  {
    "vim-denops/denops.vim",
    lazy = false, -- 起動時に読み込む
    config = function()
      -- Denoの実行パスを指定（home-managerでインストールした場合）
      if vim.fn.executable("deno") == 1 then
        vim.g.denops_deno = vim.fn.exepath("deno")
      end
      -- Disable shared server (each Neovim instance will have its own denops server)
      vim.g.denops_server_addr = nil
      -- Silent mode to reduce startup messages
      vim.g.denops_silent = 1
    end,
  },
}