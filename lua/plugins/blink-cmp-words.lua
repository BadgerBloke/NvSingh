return {
  "saghen/blink.cmp",
  dependencies = { "archie-judd/blink-cmp-words" },
  opts = {
    -- ...
    -- Optionally add 'dictionary', or 'thesaurus' to default sources
    sources = {
      default = { "lsp", "path", "lazydev" },
      providers = {

        -- Use the thesaurus source
        thesaurus = {
          name = "blink-cmp-words",
          module = "blink-cmp-words.thesaurus",
          -- All available options
          opts = {
            -- A score offset applied to returned items.
            -- By default the highest score is 0 (item 1 has a score of -1, item 2 of -2 etc..).
            score_offset = 0,

            -- Default pointers define the lexical relations listed under each definition,
            -- see Pointer Symbols below.
            -- Default is as below ("antonyms", "similar to" and "also see").
            pointer_symbols = { "!", "&", "^" },
          },
        },

        -- Use the dictionary source
        dictionary = {
          name = "blink-cmp-words",
          module = "blink-cmp-words.dictionary",
          -- All available options
          opts = {
            -- The number of characters required to trigger completion.
            -- Set this higher if completion is slow, 3 is default.
            dictionary_search_threshold = 3,

            -- See above
            score_offset = 0,

            -- See above
            pointer_symbols = { "!", "&", "^" },
          },
        },
      },

      -- Setup completion by filetype
      per_filetype = {
        text = { "dictionary" },
        markdown = { "thesaurus" },
        typescript = { "dictionary" },
        javascript = { "dictionary" },
        rust = { "dictionary" },
        python = { "dictionary" },
        lua = { "dictionary" },
        go = { "dictionary" },
        sh = { "dictionary" },
      },
    },
    -- ...
  },
  -- ...
}
