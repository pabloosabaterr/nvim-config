-- Java con jdtls (macOS: brew install jdtls; Arch: AUR jdtls; necesita JDK 21+)
-- Debug y tests opcionales: si existen los bundles de java-debug y vscode-java-test
-- en ~/.local/share/java se cargan solos (ver README de nvim-jdtls).

local bundle_dir = vim.fn.expand("~/.local/share/java")

local function bundles()
  local b = vim.fn.glob(bundle_dir
    .. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", true, true)
  for _, jar in ipairs(vim.fn.glob(bundle_dir .. "/vscode-java-test/server/*.jar", true, true)) do
    local name = vim.fn.fnamemodify(jar, ":t")
    -- Estos dos jars rompen jdtls si se cargan como bundles
    if name ~= "com.microsoft.java.test.runner-jar-with-dependencies.jar" and name ~= "jacocoagent.jar" then
      table.insert(b, jar)
    end
  end
  return b
end

local function start()
  local root = vim.fs.root(0, { "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", ".git" })
    or vim.fn.getcwd()
  -- Un workspace por proyecto, fuera del repo
  local workspace = vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fn.fnamemodify(root, ":p:h:t") .. "-" .. vim.fn.sha256(root):sub(1, 8)

  local jdtls = require("jdtls")
  local init_bundles = bundles()
  jdtls.start_or_attach({
    cmd = { "jdtls", "-data", workspace },
    root_dir = root,
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    init_options = { bundles = init_bundles },
    settings = {
      java = {
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" }, -- ver código de .class
        inlayHints = { parameterNames = { enabled = "all" } },
        completion = {
          favoriteStaticMembers = {
            "org.junit.jupiter.api.Assertions.*",
            "org.mockito.Mockito.*",
            "java.util.Objects.requireNonNull",
          },
        },
        sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
      },
    },
    on_attach = function(_, buf)
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
      end
      map("n", "<leader>jv", jdtls.extract_variable, "Extraer variable")
      map("x", "<leader>jv", function() jdtls.extract_variable(true) end, "Extraer variable")
      map("n", "<leader>jc", jdtls.extract_constant, "Extraer constante")
      map("x", "<leader>jc", function() jdtls.extract_constant(true) end, "Extraer constante")
      map("x", "<leader>jm", function() jdtls.extract_method(true) end, "Extraer método")
      map("n", "<leader>ju", jdtls.update_projects_config, "Recargar build (pom/gradle)")

      if #init_bundles > 0 then
        jdtls.setup_dap({ hotcodereplace = "auto" })
        require("jdtls.dap").setup_dap_main_class_configs()
        map("n", "<leader>jt", jdtls.test_class, "Test de la clase")
        map("n", "<leader>jT", jdtls.test_nearest_method, "Test del método")
      end
    end,
  })
end

return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_jdtls", { clear = true }),
      pattern = "java",
      callback = start,
    })
    -- El primer buffer ya disparó FileType antes de cargar el plugin
    if vim.bo.filetype == "java" then start() end
  end,
}
