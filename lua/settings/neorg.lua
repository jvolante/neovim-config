require('neorg').setup {
    load = {
        ['core.defaults'] = {},
        ['core.norg.concealer'] = {},
        ['core.norg.dirman'] = {
            config = {
                workspaces = {
                    default = '~/notes'
                }
            }
        }
    },
}
