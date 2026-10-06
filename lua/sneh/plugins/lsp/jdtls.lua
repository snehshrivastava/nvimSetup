return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  config = function()
    local jdtls = require("jdtls")
    local mason_registry = require("mason-registry")

    -- find lombok jar for the launch-time javaagent. This patches jdtls's own
    -- Eclipse JDT/OSGi classes (compiled for Java 17+, class file major
    -- version 61+), not the project being edited - a project's pinned lombok
    -- version can be years old (e.g. 1.18.12) and its bundled ASM can't parse
    -- those class files, crashing the agent with "Unsupported class file
    -- major version 61" on every class jdtls loads. So this always prefers a
    -- current standalone jar over whatever the project itself resolved.
    local function find_lombok_jar()
      local standalone = vim.fn.expand("~/.local/share/java/lombok.jar")
      if vim.uv.fs_stat(standalone) then
        return standalone
      end

      local candidates = {}
      vim.list_extend(
        candidates,
        vim.fn.glob(vim.fn.expand("~") .. "/.m2/repository/org/projectlombok/lombok/*/lombok-*.jar", false, true)
      )
      vim.list_extend(
        candidates,
        vim.fn.glob(
          vim.fn.expand("~") .. "/.gradle/caches/modules-2/files-2.1/org.projectlombok/lombok/*/*/lombok-*.jar",
          false,
          true
        )
      )
      candidates = vim.tbl_filter(function(p)
        return not p:match("sources%.jar$") and not p:match("javadoc%.jar$")
      end, candidates)
      table.sort(candidates)
      return candidates[#candidates] or standalone
    end

    -- the mason jdtls python launcher has no JDTLS_JVM_ARGS env hook - it only
    -- accepts extra JVM options via a repeatable --jvm-arg=... CLI flag
    local lombok_jvm_arg = "--jvm-arg=-javaagent:" .. find_lombok_jar()

    -- java-debug / java-test bundles, mason-installed by mason-tool-installer
    local bundles = {}
    local java_debug_path = mason_registry.get_package("java-debug-adapter"):get_install_path()
    vim.list_extend(
      bundles,
      vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true, true)
    )

    local java_test_path = mason_registry.get_package("java-test"):get_install_path()
    vim.list_extend(bundles, vim.fn.glob(java_test_path .. "/extension/server/*.jar", true, true))

    -- ft="java" only lazy-loads this config() once, for the first java buffer;
    -- start_or_attach must run per buffer or later java buffers get no LSP.
    -- The root is resolved per buffer too: computed once up here, every java
    -- file - even one from a different repo - attached to the first repo's
    -- server and workspace. A different root_dir makes start_or_attach spawn
    -- a separate client; the same root reuses the existing one.
    local function attach(args)
      local bufnr = args and args.buf or vim.api.nvim_get_current_buf()
      local root_dir = vim.fs.root(bufnr, { "gradlew", "mvnw", ".git" }) or vim.fn.getcwd()
      local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
      jdtls.start_or_attach({
        cmd = { "jdtls", lombok_jvm_arg, "-data", workspace_dir },
        root_dir = root_dir,
        -- jdtls server itself requires Java 21+ to launch; scoped to this
        -- process only, does not touch system JAVA_HOME (project stays on 11)
        cmd_env = {
          JAVA_HOME = "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home",
        },
        init_options = {
          bundles = bundles,
        },
        on_attach = function(_, bufnr)
          -- wires dap.adapters.java / dap.configurations.java from the
          -- java-debug bundle above; without this, debug configs never exist
          jdtls.setup_dap({ config_overrides = {} })
          require("jdtls.dap").setup_dap_main_class_configs()

          -- jdtls's type index doesn't always pick up a newly-added member on
          -- save alone; these force a reindex without leaving nvim
          local opts = { buffer = bufnr, silent = true }
          opts.desc = "JDTLS: full workspace recompile"
          vim.keymap.set("n", "<leader>jc", function()
            jdtls.compile("full")
          end, opts)

          opts.desc = "JDTLS: wipe workspace index and restart"
          vim.keymap.set("n", "<leader>jw", function()
            jdtls.setup.wipe_data_and_restart()
          end, opts)
        end,
      }, nil, { bufnr = bufnr })
    end

    attach()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = attach,
    })
  end,
}
