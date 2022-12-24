Add-Type -TypeDefinition "
public interface IWcmItem
{
    string Key { get; }
    string Name { get; }
    string IconPath { get; }
}

public interface IWcmRootItem : IWcmItem
{
    string Type { get; }
    bool Extended { get; }
    string Position { get; }
}

public interface IWcmSubItem : IWcmItem { }

public interface IWcmCommandItem : IWcmItem
{
    string Command { get; }
}

public interface IWcmGroupItem : IWcmItem
{
    IWcmItem[] Children { get; }
}

public interface IWcmRootCommandItem : IWcmRootItem, IWcmCommandItem { }

public interface IWcmSubCommandItem : IWcmSubItem, IWcmCommandItem { }

public interface IWcmRootGroupItem : IWcmRootItem, IWcmGroupItem { }

public interface IWcmSubGroupItem : IWcmSubItem, IWcmGroupItem { }
"
