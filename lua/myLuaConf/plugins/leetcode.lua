return {
  {
    "leetcode.nvim",
    for_cat = "general.extra",
    cmd = { "Leet" },
    after = function()
      require("leetcode").setup({
        lang = "typescript",
        image_support = false, -- breaks soft-wrapping problem descriptions
        injector = {
          ["rust"] = {
            before = {
              "#[allow(dead_code)]",
              "fn main(){}",
              "#[allow(dead_code)]",
              "struct Solution;",
            },
          },
          ["typescript"] = {
            imports = function(default_imports)
              vim.list_extend(default_imports, {})
              return default_imports
            end,
          },
        },
        hooks = {
          ["question_enter"] = {
            function(question)
              local cjson = vim.json
              local qpath = question:path()
              local config = require("leetcode.config")
              local repo = config.user.storage.home
              local qid = question.q.frontend_id
              local title = question.q.title_slug

              local function write_file(handle, content, name, path)
                local formatted = (content:gsub(" +", "")):format(name, path)
                handle:write(formatted)
                handle:close()
              end
              local function mk_cargo_toml()
                local cargo_toml = vim.fs.joinpath(repo, "/Cargo.toml")
                local content = [[
                    [package]
                    name = "leetcode"
                    edition = "2024"

                    [lib]
                    name = "%s"
                    path = "%s"

                    [dependencies]
                    rand = "0.8"
                    regex = "1"
                    itertools = "0.14.0"
                  ]]
                local file = io.open(cargo_toml, "w")
                if file then
                  write_file(file, content, qid .. "_" .. title, qpath)
                else
                  print("Failed to open file: " .. cargo_toml)
                end
              end

              local function mk_tsconfig()
                local tsconfig_json = vim.fs.joinpath(repo, "tsconfig.json")
                local tsconfig_data = {
                  compilerOptions = {
                    target = "ES2024",
                    module = "nodenext",
                    strict = true,
                    alwaysStrict = true,
                  },
                }
                local content = cjson.encode(tsconfig_data)
                local tsconfig_file = io.open(tsconfig_json, "w")
                if tsconfig_file then
                  write_file(tsconfig_file, content, tsconfig_json, qpath)
                else
                  print("Failed to open file: " .. tsconfig_json)
                end
              end

              local function mk_package()
                local package_json = vim.fs.joinpath(repo, "package.json")
                local package_data = {
                  {
                    name = "@redbeardymcgee/leetcode-ts",
                    version = "0.0.0",
                    license = "MIT",
                    type = "module",
                    main = "index.ts",
                    description = "leetcode in ts",
                  },
                }
                local package_content = cjson.encode(package_data)
                local package_file = io.open(package_content, "w")
                if package_file then
                  write_file(package_file, package_content, package_json, qpath)
                else
                  print("Failed to open file: " .. package_json)
                end
              end

              if question.lang == "rust" then
                mk_cargo_toml()
              elseif question.lang == "typescript" then
                mk_tsconfig()
                mk_package()
                os.execute("npm install -y --save lodash datastructures-js")
                os.execute("npm install -y --save-dev typescript")
              end
            end,
          },
        },
      })
    end,
  },
  {
    "aoc.nvim",
    for_cat = "general.extra",
    cmd = {
      "AocGetPuzzleInput",
      "AocGetTodayPuzzleInput",
      "AocClearCache",
      "AocInspectConfig",
      "AocReloadSessionToken",
    },
    after = function()
      require("aoc").setup({
        session_filepath = vim.fn.expand(
          "~/src/redbeardymcgee/aoc/session.txt"
        ),
      })
    end,
  },
}
