$basePath = "Registry::HKEY_CLASSES_ROOT"

$ContextMenuPathType =
@{
    File      = "$basePath\``*\shell"
    Directory = "$basePath\Directory\shell"
    Desktop   = "$basePath\Directory\background\shell"
    Drive     = "$basePath\Drive\shell"
}

$RegistryKeys =
@{
    Shell   = 'Shell'
    Command = 'Command'
}

$RegistryProperties =
@{
    Default     = '(default)'
    MUIVerb     = 'MUIVerb'
    Subcommands = 'Subcommands'
    Icon        = 'Icon'
    Extended    = 'Extended'
    Position    = 'Position'
}
