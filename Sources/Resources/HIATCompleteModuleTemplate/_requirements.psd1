@{
    PSDependOptions = @{
        Target             = '$pwd/Dependencies'
        SkipPublisherCheck = $true
        AddToPath          = $true
    }
    'BuildHelpers'    = @{
        Version = '2.0.15'
    }
    'PSake' = @{
        Version = '4.9.0'
    }
    'InvokeBuild' = @{
        Version = '5.6.2'
    }
}